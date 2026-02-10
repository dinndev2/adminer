class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business
  
  def create
    @service = @business.services.new(service_params)

    if @service.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("services-empty"),
            turbo_stream.append("services", @service)
          ]
        end
        format.html { redirect_to business_services_path(@business) }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def index
    @services = @business.services
  end

  def edit
    @service = @business.services.find(params[:id])
    render layout: false
  end

  def new 
    @service = Service.new
    render layout: false
  end

  def search
    q = params[:q].to_s.strip
    s = @business.services
    @services = if q.length >= 1
      s.where("name ILIKE ?", "%#{q}%")
    else
      s.limit(20)
    end

    render json: @services.map do |service|
      {
        name: service.name,
        desciption: service.description
      }
    end
  end

  def update
    @service = @business.services.find(params[:id])

    if @service.update(service_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@service) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service = @business.services.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@service) }
      format.html { redirect_to business_services_path(@business) }
    end
  end

  private
  
  def set_business
    @business = Business.find(params[:business_id])
  end

  def service_params
    params.expect(service: [:name, :description, :price, :business_id])
  end
end
