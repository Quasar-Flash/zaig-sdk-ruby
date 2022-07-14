# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zaig do
  describe ".configure" do
    subject { described_class.configuration }

    before do
      described_class.configuration = nil
      ENV.clear
    end

    describe "attributes" do
      subject(:test_env) { described_class.configuration.env }

      let(:test_base_url) { described_class.configuration.base_url }

      context "when configuration is defined" do
        before do
          described_class.configure do |config|
            config.base_url = "base_url"
          end
        end

        it { expect(test_base_url).to eq("base_url") }
      end

      context "when configuration is not defined" do
        it { expect(test_base_url).to be_nil }
      end

      describe "I18n calls" do
        it { expect(I18n.default_locale).to eq(:en) }

        it { expect(I18n.config.available_locales).to contain_exactly(:en, :"pt-BR") }
      end
    end
  end
end
