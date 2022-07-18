# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zaig::Entities::Response do
  describe "#status" do
    subject(:statuses) { described_class.statuses }

    it { expect(statuses).to have_attributes(count: 7) }
  end

  describe "#approved?" do
    subject(:approved?) { described_class.new(analysis_status: status).approved? }

    context "when the status is valid" do
      let(:status) { described_class::APPROVAL_STATUS.sample }

      it { expect(approved?).to be_truthy }
    end

    context "when the status is invalid" do
      let(:status) { described_class::REPROVAL_STATUS.sample }

      it { expect(approved?).to be_falsey }
    end
  end

  describe "#rejected?" do
    subject(:reproved?) { described_class.new(analysis_status: status).rejected? }

    context "when the status is valid" do
      let(:status) { described_class::REPROVAL_STATUS.sample }

      it { expect(reproved?).to be_truthy }
    end

    context "when the status is invalid" do
      let(:status) { described_class::APPROVAL_STATUS.sample }

      it { expect(reproved?).to be_falsey }
    end
  end

  describe "#pending?" do
    subject(:reproved?) { described_class.new(analysis_status: status).pending? }

    context "when the status is valid" do
      let(:status) { described_class::PENDING_STATUS.sample }

      it { expect(reproved?).to be_truthy }
    end

    context "when the status is invalid" do
      let(:status) { described_class::APPROVAL_STATUS.sample }

      it { expect(reproved?).to be_falsey }
    end
  end
end
