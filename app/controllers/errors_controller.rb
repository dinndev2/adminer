class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render :not_found, status: :not_found }
      format.all { head :not_found }
    end
  end
end
