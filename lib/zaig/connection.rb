# frozen_string_literal: true

module Zaig
  # Class to instance a authenticated connection object.
  class Connection < Flash::Integration::Connection
    def initialize(request_class: Faraday, base_url: Zaig.configuration.base_url, access_token: Zaig.configuration.access_token)
      @access_token = access_token

      super(request_class: request_class, base_url: base_url)
    end

    def default_headers
      {
        "Content-Type": "application/json",
        Accept: "application/json",
        "x-api-key": @access_token
      }
    end
  end
end
