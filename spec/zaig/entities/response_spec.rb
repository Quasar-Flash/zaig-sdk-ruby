# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zaig::Entities::Response do
  describe "#approved?" do
    subject(:approved_call) { described_class.new(analysis_status: "automatically_approved").approved? }

    it { expect(approved_call).to be_truthy }
  end
end
