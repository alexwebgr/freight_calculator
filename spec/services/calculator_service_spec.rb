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
        allow(map_reduce).to receive(:aggregated_sailings).and_return([
          {
            arrival_date: "2022-03-05",
            departure_date: "2022-01-30",
            destination_port: "NLRTM",
            origin_port: "CNSHA",
            sailing_code: "MNOD",
            rate: "556.78",
            rate_currency: "USD"
          },
          {
            arrival_date: "2022-03-05",
            departure_date: "2022-01-30",
            destination_port: "NLRTM",
            origin_port: "CNSHA",
            sailing_code: "MNOA",
            rate: "456.78",
            rate_currency: "EUR"
          },
          {
            arrival_date: "2022-03-05",
            departure_date: "2022-01-30",
            destination_port: "NLRTM",
            origin_port: "CNSHA",
            sailing_code: "MNOP",
            rate: "456.78",
            rate_currency: "USD"
          }
        ])
      end

      it "returns the expected output" do
        expect(subject).to eq expected_output
      end
    end
  end
end
