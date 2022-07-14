# frozen_string_literal: true

module Zaig
  # Default library error
  class BaseError < StandardError
    def initialize(message = self.class.default_message)
      super
    end
  end
end
