require_relative "../spec_helper"
require_relative "../../app/services/input_parser_service"

describe InputParserService do
  let(:input_string) { nil }
  subject { described_class.call(input_string) }

  describe "#call" do
    context "when input_string is empty" do
      let(:input_string) { "" }
      let(:expected_output) { {} }

      it "returns an empty hash" do
        expect(subject).to eq expected_output
      end
    end

    context "when input_string is nil" do
      let(:expected_output) { {} }

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
          origin_port: "CNSHA",
          destination_port: "NLRTM",
          criteria: "cheapest-direct"
        }
      }

      it "returns the expected output" do
        expect(subject).to eq expected_output
      end
    end
  end
end
