require 'rails_helper'

RSpec.describe CreatePayment do
  let(:patient) { FactoryBot.create(:user, :patient) }

  it 'creates a payment record' do
    expect{ CreatePayment.new(patient).execute }.to change(Payment, :count).by(1)
  end

end
