require 'rails_helper'

RSpec.describe DoctorMessagesController, type: :request do
  let!(:patient) { FactoryBot.create(:user, :patient) }
  let!(:doctor) { FactoryBot.create(:user, :doctor) }

  let!(:patient_inbox) { FactoryBot.create(:inbox, user_id: patient.id) }
  let!(:patient_outbox) { FactoryBot.create(:outbox, user_id: patient.id) }

  let!(:doctor_inbox) { FactoryBot.create(:inbox, user_id: doctor.id) }
  let!(:doctor_outbox) { FactoryBot.create(:outbox, user_id: doctor.id) }

  let!(:text) { 'This is a text message' }
  let!(:params) { { message: { body: 'This is a text message' } } }

  describe 'GET /index' do
    it 'calls index method' do
      get doctor_messages_path
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let!(:message) {
      FactoryBot.create(
        :message,
        :sent_less_than_a_week_ago,
        inbox_id: patient_inbox.id,
        outbox_id: doctor_outbox.id,
        read: false
      )
    }
    it 'calls show method and updates a message from unread to read' do
      expect(patient.inbox.messages.unread.count).to eq(1)
      get doctor_message_path(message)
      expect(response).to be_successful

      message.reload
      expect(message.read).to be_truthy
      expect(patient.inbox.messages.unread.count).to eq(0)
    end
  end
end
