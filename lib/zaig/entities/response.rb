# frozen_string_literal: true

module Zaig
  module Entities
    # Class to create registration response objects.
    class Response
      attr_reader :analysis_status, :credit_proposal_legal_person_key, :message,
                  :raw_data, :reason, :request, :status_code, :zaig_id

      # Collection with all the approval statuses.
      APPROVAL_STATUS = %i[automatically_approved manually_approved].freeze

      # Collection with all the pending statuses.
      PENDING_STATUS = %i[pending in_manual_analysis in_manual_analysis].freeze

      # Colllection with all the reproval statuses.
      REPROVAL_STATUS = %i[automatically_reproved manually_reproved].freeze

      def initialize(analysis_status: nil, credit_proposal_legal_person_key: nil, message: nil,
                     raw_data: nil, reason: nil, request: nil, status_code: nil, zaig_id: nil)
        @analysis_status = analysis_status.nil? ? nil : analysis_status.to_s.strip.downcase.to_sym
        @credit_proposal_legal_person_key = credit_proposal_legal_person_key
        @message = message
        @raw_data = raw_data
        @reason = reason
        @request = request
        @status_code = status_code
        @zaig_id = zaig_id
      end

      # Retrieve all the available statuses.
      def self.statuses
        %i[automatically_approved automatically_reproved in_manual_analysis manually_approved manually_reproved waiting_for_data pending]
      end

      # Check if the registration is approved.
      def approved?
        APPROVAL_STATUS.include?(analysis_status)
      end

      # Check if the registration still not done.
      def pending?
        PENDING_STATUS.include?(analysis_status)
      end

      # Check if the registration is reproved.
      def rejected?
        REPROVAL_STATUS.include?(analysis_status)
      end

      alias not_approved? rejected?
    end
  end
end
