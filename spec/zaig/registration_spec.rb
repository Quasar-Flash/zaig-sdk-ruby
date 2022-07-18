# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zaig::Registration do
  describe "#call" do
    subject(:call_registration) { described_class.instance.call(args) }

    let(:args) { JSON.parse(File.read("spec/fixtures/registration/valid_registration_payload.json"), symbolize_names: true) }
    let(:response) { instance_double(Flash::Integration::Response) }
    let(:base_url) { "http://localhost" }
    let(:endpoint) { described_class::ENDPOINT }
    let(:headers) { JSON.parse(File.read("spec/fixtures/default_headers.json")) }
    let(:payload) { Zaig::RegistrationPayload.instance.call(args) }

    before do
      Zaig.configure do |c|
        c.base_url = base_url
      end

      allow(args).to receive(:key?) { true }

      stub_request(:post, "#{base_url}/#{endpoint}")
        .with(body: payload.to_json, headers: headers)
        .to_return(status: response_status, body: response_body, headers: {})
    end

    context "when the server status is 200" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/success_registration_response.json")).to_json }
      let(:response_status) { 200 }

      it { expect(call_registration).to be_kind_of(Zaig::Entities::Response) }

      it do
        expect(call_registration).to have_attributes(
          analysis_status: :automatically_approved,
          credit_proposal_legal_person_key: "b1d2e8c4-0d06-43aa-a885-f10f5dbe1d5d",
          message: "Proposta Enviado para a Zaig",
          raw_data: response_body,
          reason: "automatically_approved",
          status_code: 200,
          zaig_id: "9249eeee-fa76-42f3-9a7d-f728ebd1b1a0"
        )
      end
    end

    context "when the server status is 400" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/invalid_error_response.json")).to_json }
      let(:response_status) { 400 }

      it { expect { call_registration }.to raise_error(Zaig::FieldValidationError) }
    end

    context "when the server status is 400 and has no resposta_zaig" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/field_validation_error.json")).to_json }
      let(:response_status) { 400 }

      it { expect { call_registration }.to raise_error(Zaig::FieldValidationError) }
    end

    context "when the server status is 422" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/entity_error.json")).to_json }
      let(:response_status) { 400 }

      it { expect { call_registration }.to raise_error(Zaig::UnprocessableEntityError) }
    end

    context "when the server status is 409" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/registration_already_exists.json")).to_json }
      let(:response_status) { 409 }

      it { expect { call_registration }.to raise_error(Zaig::AlreadyExistsError) }
    end

    context "when the server status is 408" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/timeout_error_response.json")).to_json }
      let(:response_status) { 400 }

      it { expect { call_registration }.to raise_error(Zaig::ExternalTimeoutError) }
    end

    context "when the internal server status is 501" do
      let(:response_body) { {}.to_json }
      let(:response_status) { 501 }

      it { expect { call_registration }.to raise_error(Zaig::ServerError) }
      # it { expect { call_registration }.to raise_error(Zaig::UnexpectedError) }
    end

    context "when zaig returns an unexpected status" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/zaig_unexpected_status.json")).to_json }
      let(:response_status) { 400 }

      it { expect { call_registration }.to raise_error(Zaig::UnexpectedError) }
    end

    context "when internal server doesnt bring the resposta_zaig_field" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/irregular_response.json")).to_json }
      let(:response_status) { 500 }

      it { expect { call_registration }.to raise_error(Zaig::ServerError) }
    end
  end
end
