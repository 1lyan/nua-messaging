require 'rails_helper'

RSpec.describe PrescriptionsController, type: :request do
  let!(:patient) { FactoryBot.create(:user, :patient) }
  let!(:admin) { FactoryBot.create(:user, :admin) }

  let!(:patient_inbox) { FactoryBot.create(:inbox, user_id: patient.id) }
  let!(:patient_outbox) { FactoryBot.create(:outbox, user_id: patient.id) }

  let!(:admin_inbox) { FactoryBot.create(:inbox, user_id: admin.id) }
  let!(:admin_outbox) { FactoryBot.create(:outbox, user_id: admin.id) }

  describe "POST /create" do
    context 'message is sent to admin' do
      it 'sends a message to an admin' do
        expect(patient.payments.count).to eq(0)
        expect(patient.outbox.messages.count).to eq(0)
        expect(admin.inbox.messages.count).to eq(0)

        expect(PaymentProviderFactory).to receive(:provider).and_return(Provider.new)
        post prescriptions_path, params: {}

        expect(response).to be_successful

        text = PrescriptionsController::REISSUE_PRESCRIPTION_TEXT
        expect(patient.outbox.messages.first.body).to eq(text)
        expect(admin.inbox.messages.first.body).to eq(text)
        expect(patient.payments.count).to eq(1)
      end
    end

  end
end
