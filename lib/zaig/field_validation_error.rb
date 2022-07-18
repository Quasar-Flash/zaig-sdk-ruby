# frozen_string_literal: true

module Zaig
  class FieldValidationError < BaseError
    attr_accessor :detail
  end
end
