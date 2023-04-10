# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "zaig/version"

Gem::Specification.new do |s|
  s.name        = "zaig"
  s.version     = Zaig::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Zaig SDK"
  s.description = "SDK to consume the Zaig services"
  s.authors     = ["Danilo Carolino"]
  s.email       = "danilo.carolino@qflash.com.br"
  s.required_ruby_version = ">= 2.7"
  s.files = Dir["{lib}/**/*"] + Dir["{docs}/**/*"] + ["Rakefile"]

  s.add_dependency             "cpf_cnpj"
  s.add_dependency             "flash_integration"
  s.add_dependency             "jwt"

  s.add_development_dependency "bundler", "~> 2.3", ">= 2.3.0"
  s.add_development_dependency "factory_bot", "~> 6.2"
  s.add_development_dependency "pry", "~> 0.14.1"
  s.add_development_dependency "rake", "~> 13.0.6", ">= 10.0.0"
  s.add_development_dependency "rspec", "~> 3.12.0"
  s.add_development_dependency "rubocop", "~> 1.50.0"
  s.add_development_dependency "rubocop-faker", "~> 1.1.0"
  s.add_development_dependency "rubocop-i18n", "~> 3.0.0"
  s.add_development_dependency "rubocop-packaging", "~> 0.5.2"
  s.add_development_dependency "rubocop-performance", "~> 1.17.1"
  s.add_development_dependency "rubocop-rspec", "~> 2.19.0"
  s.add_development_dependency "rubocop-thread_safety", "~> 0.5.1"
  s.add_development_dependency "simplecov", "~> 0.22.0"
  s.add_development_dependency "simplecov-json", "~> 0.2.3"
  s.add_development_dependency "webmock", "~> 3.18.1"
  s.metadata["rubygems_mfa_required"] = "true"
end
