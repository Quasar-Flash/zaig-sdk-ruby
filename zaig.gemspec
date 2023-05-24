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
  s.metadata["rubygems_mfa_required"] = "true"
  s.add_dependency "cpf_cnpj"
  s.add_dependency "flash_integration"
  s.add_dependency "jwt"
end
