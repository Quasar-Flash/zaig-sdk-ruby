# frozen_string_literal: true

module Integration
  module Zaig
    class Connection < Flash::Integration::Connection
      def initialize(request_class: Faraday, base_url: Settings.qlife.score.base_url)
        super(request_class: request_class, base_url: base_url)
      end

      def default_headers
        # TODO: set the auth api key
        {
          "Content-Type": "application/json",
          Accept: "application/json",
          "x-api-key": ""
        }
      end
    end
  end
end
