# frozen_string_literal: true

module Zaig
  module Entities
    # Class to create registration response objects.
    class Response
      attr_reader :analysis_status, :credit_proposal_legal_person_key, :message,
                  :raw_data, :reason, :request, :status_code, :zaig_id

      def initialize(analysis_status: nil, credit_proposal_legal_person_key: nil, message: nil,
                     raw_data: nil, reason: nil, request: nil, status_code: nil, zaig_id: nil)
        @analysis_status = analysis_status
        @credit_proposal_legal_person_key = credit_proposal_legal_person_key
        @message = message
        @raw_data = raw_data
        @reason = reason
        @request = request
        @status_code = status_code
        @zaig_id = zaig_id
      end

      def approved?
        analysis_status == "automatically_approved"
      end
    end
  end
end
