# frozen_string_literal: true

require "cpf_cnpj"
require "flash_integration"
require "i18n"
require "jwt"
require "singleton"

require "zaig/base_error"
require "zaig/already_exists_error"
require "zaig/external_timeout_error"
require "zaig/field_validation_error"
require "zaig/server_error"
require "zaig/server_timeout_error"
require "zaig/unexpected_error"
require "zaig/unprocessable_entity_error"
require "zaig/validation_error"

require "zaig/entities/response"

require "zaig/registration_payload"
require "zaig/connection"
require "zaig/registration"
require "zaig/version"

I18n.load_path += Dir[File.join(__dir__, "locales", "**/*.yml")]
I18n.reload! if I18n.backend.initialized?

# Zaig integration module
module Zaig
  # rubocop:disable ThreadSafety/ClassAndModuleAttributes
  # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    self.configuration ||= Configuration.new

    yield(configuration)
  end

  # rubocop:enable ThreadSafety/ClassAndModuleAttributes
  # rubocop:enable ThreadSafety/InstanceVariableInClassMethod

  # Basic configuration settings
  class Configuration
    attr_accessor :base_url, :jwt_secret, :jwt_user
    attr_writer :jwt_algorithm, :jwt_exp_time, :registration_endpoint

    def jwt_algorithm
      @jwt_algorithm ||= "HS256"
    end

    def jwt_exp_time
      @jwt_exp_time ||= 1_658_439_475
    end

    def registration_endpoint
      @registration_endpoint ||= "zaig/consulta_de_credito"
    end
  end
end
