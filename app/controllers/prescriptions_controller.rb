class PrescriptionsController < ApplicationController

  REISSUE_PRESCRIPTION_TEXT = 'Hello, esteemed sir. I lost my prescription and would like to kindly ask you to issue a new one. Sincerely'

  def create
    ActiveRecord::Base.transaction do
      Message.create!(
        outbox_id: current_user.outbox.id,
        inbox_id: User.default_admin.inbox.id,
        body: REISSUE_PRESCRIPTION_TEXT
      )
      CreatePayment.new(current_user).execute
    end

    PaymentProviderFactory.provider.debit_card(current_user)
    redirect_to '/', status: 200
  end

  protected
  def current_user
    User.current
  end
end
