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

  def service_params
    params.expect(service: [:name, :description])
  end
end
