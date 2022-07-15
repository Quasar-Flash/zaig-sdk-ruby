# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zaig::RegistrationPayload do
  describe "#call" do
    subject(:call_method) { described_class.instance.call(args) }

    let(:args) { JSON.parse(File.read("spec/fixtures/registration/valid_registration_payload.json"), symbolize_names: true) }

    it { expect(call_method).to include(:address) }

    it { expect(call_method).to include(:client_category) }

    it { expect(call_method).to include(:constitution_date) }

    it { expect(call_method).to include(:constitution_type) }

    it { expect(call_method).to include(:credit_request_date) }

    it { expect(call_method).to include(:credit_type) }

    it { expect(call_method).to include(:document_number) }

    it { expect(call_method).to include(:email) }

    it { expect(call_method).to include(:financial) }

    it { expect(call_method).to include(:guarantors) }

    it { expect(call_method).to include(:id) }

    it { expect(call_method).to include(:legal_name) }

    it { expect(call_method).to include(:monthly_revenue) }

    it { expect(call_method).to include(:phones) }

    it { expect(call_method).to include(:shareholders) }

    it { expect(call_method).to include(:source) }

    it { expect(call_method).to include(:scr_parameters) }

    it { expect(call_method).to include(:trading_name) }

    it { expect(call_method).to include(:warrants) }
  end
end
