# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zaig::Registration do
  describe "#call" do
    subject(:call_registration) { described_class.instance.call(args) }

    let(:args) { JSON.parse(File.read("spec/fixtures/registration/valid_registration_payload.json")) }
    let(:response) { instance_double(Flash::Integration::Response) }
    let(:base_url) { Zaig.configuration.defaults.api.base_url.freeze }
    let(:endpoint) { Zaig.configuration.defaults.api.endpoints.inquiry.credit.freeze }
    let(:headers) { JSON.parse(File.read("spec/fixtures/default_headers.json")) }

    before do
      stub_request(:post, "#{base_url}/#{endpoint}")
        .with(body: args, headers: headers)
        .to_return(status: response_status, body: response_body, headers: {})
    end

    context "when the server status is 200" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/success_registration_response.json")).to_json }
      let(:response_status) { 200 }

      it { expect(call_registration).to be_kind_of(Zaig::Entities::Response) }

      it do
        expect(call_registration).to have_attributes(
          analysis_status: "automatically_approved",
          credit_proposal_legal_person_key: "a179ca38-d71e-4f31-9185-0c71aba4c5de",
          message: "Proposta Enviado para a Zaig",
          raw_data: response_body,
          reason: "automatically_approved",
          status_code: 200,
          zaig_id: "12327933"
        )
      end
    end

    context "when the server status is 400" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/invalid_error_response.json")).to_json }
      let(:response_status) { 500 }

      it { expect { call_registration }.to raise_error(Zaig::FieldValidationError) }
    end

    context "when the server status is 422" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/entity_error.json")).to_json }
      let(:response_status) { 500 }

      it { expect { call_registration }.to raise_error(Zaig::UnprocessableEntityError) }
    end

    context "when the server status is 209" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/registration_already_exists.json")).to_json }
      let(:response_status) { 500 }

      it { expect { call_registration }.to raise_error(Zaig::AlreadyExistsError) }
    end

    context "when the server status is 408" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/timeout_error_response.json")).to_json }
      let(:response_status) { 500 }

      it { expect { call_registration }.to raise_error(Zaig::ExternalTimeoutError) }
    end

    context "when the internal server status is 501" do
      let(:response_body) { {}.to_json }
      let(:response_status) { 501 }

      it { expect { call_registration }.to raise_error(Zaig::UnexpectedError) }
    end

    context "when zaig returns an unexpected status" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/zaig_unexpected_status.json")).to_json }
      let(:response_status) { 500 }

      it { expect { call_registration }.to raise_error(Zaig::UnexpectedError) }
    end

    context "when internal server doesnt bring the resposta_zaig_field" do
      let(:response_body) { JSON.parse(File.read("spec/fixtures/registration/irregular_response.json")).to_json }
      let(:response_status) { 500 }

      it { expect { call_registration }.to raise_error(Zaig::ServerError) }
    end
  end
end
