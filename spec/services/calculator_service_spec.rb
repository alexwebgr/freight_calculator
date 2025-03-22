# frozen_string_literal: true

require_relative "../spec_helper"
require_relative "../../app/services/calculator_service"
require_relative "../../app/services/cheapest_calculator_service"

describe CalculatorService do
  let(:input_string) { nil }
  subject { described_class.call(input_string) }

  describe "#call" do
    context "when input_string is empty" do
      let(:input_string) { "" }
      let(:expected_output) { [] }

      it "returns an empty hash" do
        expect(subject).to eq expected_output
      end
    end

    context "when the criteria is cheapest-direct" do
      let(:input_string) {
        "CNSHA
        NLRTM
        cheapest-direct"
      }

      it "calls the CheapestCalculatorService" do
        expect(CheapestCalculatorService).to receive(:call)
        subject
      end
    end

    context "when the criteria is cheapest" do
      let(:input_string) {
        "CNSHA
        NLRTM
        cheapest"
      }

      it "calls the CheapestCalculatorService" do
        expect(CheapestCalculatorService).to receive(:call)
        subject
      end
    end

    context "when the criteria is fastest-direct" do
      let(:input_string) {
        "CNSHA
        NLRTM
        fastest-direct"
      }

      it "calls the FastestCalculatorService" do
        expect(FastestCalculatorService).to receive(:call)
        subject
      end
    end

    context "when the criteria is fastest" do
      let(:input_string) {
        "CNSHA
        NLRTM
        fastest"
      }

      it "calls the FastestCalculatorService" do
        expect(FastestCalculatorService).to receive(:call)
        subject
      end
    end
  end
end
