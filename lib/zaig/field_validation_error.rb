# frozen_string_literal: true

module Zaig
  class FieldValidationError < Zaig::BaseError
    attr_accessor :detail
  end
end
