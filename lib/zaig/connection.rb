# frozen_string_literal: true

module Zaig
  # Class to instance a authenticated connection object.
  class Connection < Flash::Integration::Connection
    JWT_EXP_TIME = DateTime.now.next_day(1).to_time.to_i.freeze

    def initialize(request_class: Faraday, base_url: Zaig.configuration.base_url)
      @jwt_algorithm = Zaig.configuration.jwt_algorithm
      @jwt_secret = Zaig.configuration.jwt_secret
      @jwt_user = Zaig.configuration.jwt_user

      super(request_class: request_class, base_url: base_url)
    end

    def default_headers
      headers = {
        "Content-Type": "application/json",
        Accept: "application/json"
      }

      return headers if @jwt_secret.nil? || @jwt_secret&.empty?

      headers[:Authorization] = "Bearer #{access_token}"
      headers
    end

    private
      def access_token
        JWT.encode({ exp: JWT_EXP_TIME, user: @jwt_user }, @jwt_secret, @jwt_algorithm)
      end
  end
end
