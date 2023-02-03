# frozen_string_literal: true

module Zaig
  # Field validation error.
  class FieldValidationError < Zaig::BaseError
    attr_accessor :detail
  end
end
