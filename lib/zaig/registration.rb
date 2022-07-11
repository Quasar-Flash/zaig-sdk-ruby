# frozen_string_literal: true

require "singleton"

module Integration
  module Zaig
    class Registration
      include Singleton

      def call(address:); end
    end
  end
end
