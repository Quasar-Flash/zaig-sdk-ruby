# frozen_string_literal: true

require "confset"
require "cpf_cnpj"
require "flash_integration"
require "i18n"

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
    attr_accessor :access_token, :base_url, :env
    attr_reader :defaults

    def initialize
      @env = "development"

      load_defaults
    end

    def load_defaults
      @defaults = Confset.load_files("lib/config/settings/#{@env}.yml")
      @base_url = @defaults.api.base_url
    end
  end
end
