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

    context "when the criteria is cheapest-direct" do
      let(:input_string) {
        "CNSHA
        NLRTM
        cheapest-direct"
      }
      let(:expected_output) {
        [
          {
            arrival_date: "2022-03-05",
            departure_date: "2022-01-30",
            destination_port: "NLRTM",
            origin_port: "CNSHA",
            sailing_code: "MNOA",
            rate: "456.78",
            rate_currency: "EUR"
          }
        ]
      }

      before do
        map_reduce = instance_double('MapReduceService')
        allow(MapReduceService).to receive(:new).and_return(map_reduce)
        allow(map_reduce).to receive(:exchange_rates).and_return(MapReduceService::PAYLOAD[:exchange_rates])
        allow(map_reduce).to receive(:aggregated_sailings).and_return(file_fixture("aggregated_sailings_1.json"))
      end

      it "returns the expected output" do
        expect(subject).to eq expected_output
      end
    end

    context "when the criteria is cheapest" do
      let(:input_string) {
        "CNSHA
        NLRTM
        cheapest"
      }
      let(:expected_output) { file_fixture("cheapest_output_1.json") }

      it "returns the expected output" do
        expect(subject).to eq expected_output
      end
    end
  end
end
