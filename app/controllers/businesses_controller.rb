class BusinessesController < ApplicationController

  def create 
    @business = Business.new(business_params)
    data = Webscraper.new(business_params[:website]).call
    @business.description = data[:description]
    
    if @business.save
      FileAttachment.new(data[:logo], @business).call
      respond_to do |format|
        format.html { redirect_to business_path(@business) }
        format.turbo_stream { redirect_to business_path(@business)}
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("business-form", partial: "businesses/form", locals: { business: @business }),
                 status: :unprocessable_entity
        end
      end
    end
  end

  def new
    @business = Business.new
  end

  def show
    @business = Business.find(params[:id])
  end

  private
  def business_params
    params.expect(business: [:name, :tenant_id, :website, :description, :logo])
  end

end
