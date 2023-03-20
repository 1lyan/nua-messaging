class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_response

  def record_invalid_response
    redirect_to '/', status: :bad_request
  end

  protected
  def current_user
    raise 'redefine me in a child class'
  end
end
