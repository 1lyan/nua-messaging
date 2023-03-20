class MessagesController < ApplicationController

  def index
    messages = User.current.inbox.messages.paginate(page: params[:page])
    render :index, locals: { messages: messages, current_user: current_user }
  end
  def show
    message = Message.find(params[:id])
    render :show, locals: { message: message }
  end

  def new
    @message = Message.new
  end

  def create
    User.current.outbox.messages.create!(permitted_params)

    redirect_to '/', status: 200
  rescue NoMethodError => e
    logger.error('Failed to send message')
    logger.error(e.message)
    redirect_to '/', status: 500
  end

  protected
  def current_user
    User.current
  end

  private

  def permitted_params
    {
      body: params[:message].permit(:body)[:body],
      read: false,
      inbox_id: recipient.inbox.id
    }
  end

  def recipient
    User.patient_initial_message.sent_less_than_a_week_ago? ? User.default_doctor : User.default_admin
  end

end
