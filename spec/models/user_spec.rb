require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { FactoryBot.create(:user, :patient) }
  let!(:inbox) { FactoryBot.create(:inbox, user_id: user.id) }
  let!(:outbox) { FactoryBot.create(:outbox, user_id: user.id) }

  let!(:message) {
    FactoryBot.create(:message, :sent_less_than_a_week_ago, inbox_id: inbox.id, outbox_id: outbox.id)
  }

  it 'returns the very first message #patient_initial_message' do
    expect(User.patient_initial_message.body).to eq(message.body)
  end
end
