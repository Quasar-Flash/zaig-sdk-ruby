# frozen_string_literal: true

require "singleton"

module Zaig
  # Class to request a registration to the remote server.
  class Registration
    attr_reader :connection

    include Singleton

    def initialize(connection: Zaig::Connection.new, registration_payload: Zaig::RegistrationPayload.instance)
      @connection = connection
      @registration_payload = registration_payload
    end

    def call(obj)
      endpoint = Zaig.configuration.defaults.api.endpoints.inquiry.credit.freeze
      payload = @registration_payload.call(obj)
      res = @connection.post(url: endpoint, body: payload.to_json)

      verify_response(res)

      # Lets parse the clueless response
      parsed_res = JSON.parse(res.body, symbolize_names: true)
      res_zaig = parsed_res[:resposta_zaig]

      ::Zaig::Entities::Response.new(
        analysis_status: res_zaig[:analysis_status],
        credit_proposal_legal_person_key: res_zaig[:credit_proposal_legal_person_key],
        message: parsed_res[:msg],
        raw_data: res.body,
        reason: res_zaig[:reason],
        request: res,
        status_code: res.status,
        zaig_id: res_zaig[:id]
      )
    end

    private
      def verify_response(res)
        return if res.status.between?(200, 299)

        raise ::Zaig::UnexpectedError, I18n.t("zaig.errors.unexpected_error") if res.status != 500

        parsed_res = JSON.parse(res.body, symbolize_names: true)

        raise ::Zaig::ServerError, I18n.t("zaig.errors.field_not_found", field_name: "resposta_zaig") unless parsed_res.key?(:resposta_zaig)

        zaig_msg = parsed_res[:resposta_zaig][:msg]
        zaig_http_status = parsed_res[:resposta_zaig][:status]

        raise_error_by_zaig_status(zaig_msg, zaig_http_status)
      end

      def raise_error_by_zaig_status(msg, status)
        case status
        when 209
          raise ::Zaig::AlreadyExistsError, msg
        when 400
          raise ::Zaig::FieldValidationError, msg
        when 408
          raise ::Zaig::ExternalTimeoutError, msg
        when 422
          raise ::Zaig::UnprocessableEntityError, msg
        else
          raise ::Zaig::UnexpectedError, msg
        end
      end
  end
end
