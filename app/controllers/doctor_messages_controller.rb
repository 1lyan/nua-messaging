class DoctorMessagesController < ApplicationController
  def index
    messages = User.default_doctor.inbox.messages.paginate(page: params[:page])
    render :index, locals: { messages: messages, current_user: current_user }
  end

  def show
    message = Message.find(params[:id])
    MarkMessageRead.new(message).execute
    render :show, locals: { message: message }
  end

  protected

  def current_user
    User.default_doctor
  end
end
