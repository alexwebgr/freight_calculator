require_relative "../spec_helper"
require_relative "../../app/services/cheapest_calculator_service"

describe CheapestCalculatorService do
  let(:input_string) { nil }
  subject { described_class.call(input_string) }

  describe "#call" do
    context "when input_string is empty" do
      let(:input_string) { "" }
      let(:expected_output) { [] }

      it "returns an empty array" do
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
        allow(MapReduceService).to receive(:call).and_return(file_fixture("aggregated_sailings_1.json"))
      end

      it "returns the expected output" do
        expect(subject).to eq expected_output
      end
    end

    context "when the criteria is cheapest" do
      context "and the indirect is the cheapest" do
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

      context "and the direct is the cheapest" do
        let(:input_string) {
          "CNSHA
          NLRTM
          cheapest"
        }
        let(:expected_output) { file_fixture("cheapest_output_2.json") }

        before do
          allow(MapReduceService).to receive(:call).and_return(file_fixture("aggregated_sailings_2.json"))
        end

        it "returns the expected output" do
          expect(subject).to eq expected_output
        end
      end

      context "and the direct and indirect are equal" do
        let(:input_string) {
          "CNSHA
          NLRTM
          cheapest"
        }
        let(:expected_output) { file_fixture("cheapest_output_3.json") }

        before do
          allow(MapReduceService).to receive(:call).and_return(file_fixture("aggregated_sailings_3.json"))
        end

        it "returns the expected output" do
          expect(subject).to eq expected_output
        end
      end
    end
  end
end
