class BookingServices
   Result = Struct.new(:record, :success?, :errors)

  def initialize(booking, columns_to_update = [], current_user = nil, index_position = nil, admin_ids=[])
    @booking = booking
    @columns_to_update = columns_to_update
    @current_user = current_user
    @business = @booking.business
    @index = index_position
    @admin_ids = admin_ids
  end

  
  def prepare
    if @booking.save
      Result.new(@booking, true, nil)
    else
      Result.new(@booking, false, @booking.errors)
    end
  end

  def move_to_next_column
    return if @columns_to_update.blank?
    current_column = @columns_to_update.first
    insert_index = @index.nil? ? -1 : @index.to_i
    Booking.transaction do
      @booking.update!(status: current_column)

      # reindex that column based on current order excluding this booking
      ids = @business.bookings.where(status: current_column).where.not(id: @booking.id).order(:position).pluck(:id)

      # insert at new index
      insert_at = insert_index.negative? ? ids.length : insert_index
      ids.insert(insert_at, @booking.id)

      # write positions 0..n
      ids.each_with_index do |id, i|
        @business.bookings.where(id: id).update_all(position: i)
      end
    end
  end

  def set
    result = self.prepare
    result
  end

  def broadcast
    move_to_next_column
  
    broadcast_user_ids = [@booking.creator_id, @booking.user_id, @admin_ids].flatten
    users_by_id = User.where(id: broadcast_user_ids.compact.uniq).index_by(&:id)
  
    broadcast_user_ids.compact.uniq.each do |user_id|
      next if @current_user && user_id == @current_user.id
      user = users_by_id[user_id]
      next unless user
  
      stream = "business:#{@business.id}:bookings:#{user.id}"
  
      Turbo::StreamsChannel.broadcast_render_to(
        stream,
        template: "bookings/move",
        locals: move_locals_for(user)
      )
    end
  
    return move_locals_for(@current_user) if @current_user
    {}
  end

  private

  def move_locals_for(user)
    scoped_bookings = user.personalized_bookings(@business)
    column_bookings = @columns_to_update.index_with do |col|
      scoped_bookings.where(status: col).order(:position)
    end

    {
      columns_to_update: @columns_to_update,
      column_bookings: column_bookings,
      column_counts: column_bookings.transform_values(&:size)
    }
  end
end
