require 'rails_helper'

RSpec.describe MarkMessageRead do
  let(:patient) { FactoryBot.create(:user, :patient) }
  let(:doctor) { FactoryBot.create(:user, :doctor) }

  let(:inbox) { FactoryBot.create(:inbox, user_id: patient.id) }
  let(:outbox) { FactoryBot.create(:outbox, user_id: patient.id) }

  let(:doctor_inbox) { FactoryBot.create(:inbox, user_id: doctor.id) }
  let(:doctor_outbox) { FactoryBot.create(:outbox, user_id: doctor.id) }

  let(:message) {
    FactoryBot.create(:message, :sent_less_than_a_week_ago, inbox_id: doctor_inbox.id, outbox_id: outbox.id, read: false)
  }

    it 'returns true for #sent_less_than_a_week_ago?' do
      MarkMessageRead.new(message).execute
      message.reload
      expect(message.read).to be_truthy
    end

end
