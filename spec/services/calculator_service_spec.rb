require_relative "../spec_helper"
require_relative "../../app/services/calculator_service"

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

    context "when input_string is valid" do
      let(:input_string) {
        "CNSHA
        NLRTM
        cheapest-direct"
      }
      let(:expected_output) {
        {
          arrival_date: "2022-03-05",
          departure_date: "2022-01-30",
          destination_port: "NLRTM",
          origin_port: "CNSHA",
          sailing_code: "MNOP",
          rate: 508.76,
          rate_currency: "EUR"
        }
      }

      it "returns the expected output" do
        expect(subject).to eq expected_output
      end
    end
  end
end
