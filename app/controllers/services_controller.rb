class ServicesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @service = Service.new(service_params)

    if @service.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.append("services", @service) }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def index
    @services = Service.all
  end

  def new 
    @service = Service.new
    render layout: false
  end

  def search
    q = params[:q].to_s.strip
    @services = if q.length >= 1
      Service.where("name ILIKE ?", "%#{q}%")
    else
      Service.first
    end

    render json: @services.map do |service|
      {
        name: service.name,
        desciption: service.description
      }
    end
  end

  private

  def service_params
    params.expect(service: [:name, :description])
  end
end
