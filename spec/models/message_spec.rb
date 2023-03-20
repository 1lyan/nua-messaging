require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:patient) { FactoryBot.create(:user, :patient) }
  let!(:doctor) { FactoryBot.create(:user, :doctor) }

  let!(:inbox) { FactoryBot.create(:inbox, user_id: patient.id) }
  let(:outbox) { FactoryBot.create(:outbox, user_id: patient.id) }

  let!(:doctor_inbox) { FactoryBot.create(:inbox, user_id: doctor.id) }
  let!(:doctor_outbox) { FactoryBot.create(:outbox, user_id: doctor.id) }

  let(:message) {
    FactoryBot.create(:message, :sent_less_than_a_week_ago, inbox_id: inbox.id, outbox_id: doctor_outbox.id)
  }
  let(:old_message) {
    FactoryBot.create(:message, :sent_more_than_a_week_ago, inbox_id: inbox.id, outbox_id: doctor_outbox.id)
  }

  context 'Actual message' do
    it 'returns true for #sent_less_than_a_week_ago?' do
      expect(message.sent_less_than_a_week_ago?).to be_truthy
    end

    it 'returns false for #sent_more_than_a_week_ago?' do
      expect(message.sent_more_than_a_week_ago?).to be_falsey
    end
  end

  context 'Old message' do
    it 'returns false for #sent_less_than_a_week_ago?' do
      expect(old_message.sent_less_than_a_week_ago?).to be_falsey
    end

    it 'returns true for #sent_more_than_a_week_ago?' do
      expect(old_message.sent_more_than_a_week_ago?).to be_truthy
    end
  end

  context 'When a new message arrives - the unread count is updated' do
    it 'checks the unread count' do
      expect(patient.inbox.messages.unread.count).to eq(0)
      FactoryBot.create(:message, :sent_less_than_a_week_ago, inbox_id: inbox.id, outbox_id: doctor_outbox.id)
      expect(patient.inbox.messages.unread.count).to eq(1)
    end
  end

end
