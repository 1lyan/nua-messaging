require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let!(:patient) { FactoryBot.create(:user, :patient) }
  let!(:doctor) { FactoryBot.create(:user, :doctor) }
  let!(:admin) { FactoryBot.create(:user, :admin) }

  let!(:patient_inbox) { FactoryBot.create(:inbox, user_id: patient.id) }
  let!(:patient_outbox) { FactoryBot.create(:outbox, user_id: patient.id) }

  let!(:doctor_inbox) { FactoryBot.create(:inbox, user_id: doctor.id) }
  let!(:doctor_outbox) { FactoryBot.create(:outbox, user_id: doctor.id) }

  let!(:admin_inbox) { FactoryBot.create(:inbox, user_id: admin.id) }
  let!(:admin_outbox) { FactoryBot.create(:outbox, user_id: admin.id) }

  let!(:text) { 'This is a text message' }
  let!(:params) { { message: { body: 'This is a text message' } } }

  describe 'GET /index' do
    it 'calls index method' do
      get messages_path
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:message) {
      FactoryBot.create(:message, :sent_less_than_a_week_ago, inbox_id: patient_inbox.id, outbox_id: doctor_outbox.id)
    }
    it 'calls show method' do
      get message_path(message)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context 'bad params' do
      it 'returns 500 status' do
        post messages_path, params: {}
        expect(response).to_not be_successful
        expect(response.status).to eq(500)
      end
    end

    context 'body is empty' do
      let!(:message) {
        FactoryBot.create(:message, :sent_less_than_a_week_ago, inbox_id: patient_inbox.id, outbox_id: doctor_outbox.id)
      }

      it 'returns 400 status' do
        post messages_path, params: { message: { body: '' } }
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end

    context 'message is sent to doctor' do
      let!(:message) {
        FactoryBot.create(:message, :sent_less_than_a_week_ago, inbox_id: patient_inbox.id, outbox_id: doctor_outbox.id)
      }

      it 'sends a message to a doctor' do
        post messages_path, params: params
        expect(response).to be_successful
        expect(patient.outbox.messages.first.body).to eq(text)
        expect(doctor.inbox.messages.first.body).to eq(text)
      end
    end

    context 'message is sent to admin' do
      let!(:message) {
        FactoryBot.create(:message, :sent_more_than_a_week_ago, inbox_id: patient_inbox.id, outbox_id: doctor_outbox.id)
      }

      it 'sends a message to an admin' do
        post messages_path, params: params
        expect(response).to be_successful
        expect(patient.outbox.messages.first.body).to eq(text)
        expect(admin.inbox.messages.first.body).to eq(text)
      end
    end

  end
end
