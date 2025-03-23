# frozen_string_literal: true

require_relative "../spec_helper"
require_relative "../../app/services/fastest_calculator_service"

describe FastestCalculatorService do
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

    context "when the criteria is fastest-direct" do
      let(:input_string) {
        "CNSHA
        NLRTM
        fastest-direct"
      }
      let(:expected_output) { file_fixture("fastest_output_1.json") }

      before do
        allow(MapReduceService).to receive(:call).and_return(file_fixture("fastest_input_1.json"))
      end

      it "returns the fastest direct" do
        expect(subject).to eq expected_output
      end

      context "and the origin does not exist" do
        let(:input_string) {
          "ELSHA
          NLRTM
          fastest-direct"
        }
        let(:expected_output) { [] }

        it "returns an empty array" do
          expect(subject).to eq expected_output
        end
      end

      context "and the destination does not exist" do
        let(:input_string) {
          "CHSHA
          RTM
          fastest-direct"
        }
        let(:expected_output) { [] }

        it "returns an empty array" do
          expect(subject).to eq expected_output
        end
      end
    end

    context "when the criteria is fastest" do
      context "and the indirect is the fastest" do
        let(:input_string) {
          "CNSHA
          NLRTM
          fastest"
        }
        let(:expected_output) { file_fixture("fastest_output_2.json") }

        before do
          allow(MapReduceService).to receive(:call).and_return(file_fixture("fastest_input_2.json"))
        end

        it "returns the two fastest legs" do
          expect(subject).to eq expected_output
        end
      end

      context "and the direct is the fastest" do
        let(:input_string) {
          "CNSHA
          NLRTM
          fastest"
        }
        let(:expected_output) { file_fixture("fastest_output_3.json") }

        before do
          allow(MapReduceService).to receive(:call).and_return(file_fixture("fastest_input_3.json"))
        end

        it "returns the fastest direct" do
          expect(subject).to eq expected_output
        end
      end

      context "and the direct and indirect are equal" do
        let(:input_string) {
          "CNSHA
          NLRTM
          fastest"
        }
        let(:expected_output) { file_fixture("fastest_output_4.json") }

        before do
          allow(MapReduceService).to receive(:call).and_return(file_fixture("fastest_input_4.json"))
        end

        it "returns both two fastest legs and the fastest direct" do
          expect(subject).to eq expected_output
        end
      end

      context "and the origin does not exist" do
        let(:input_string) {
          "ELSHA
          NLRTM
          fastest"
        }
        let(:expected_output) { [] }

        it "returns an empty array" do
          expect(subject).to eq expected_output
        end
      end

      context "and the destination does not exist" do
        let(:input_string) {
          "CHSHA
          RTM
          fastest"
        }
        let(:expected_output) { [] }

        it "returns an empty array" do
          expect(subject).to eq expected_output
        end
      end
    end

    context "and the criteria does not exist" do
      let(:input_string) {
        "ELSHA
          NLRTM
          nogo"
      }
      let(:expected_output) { [] }

      it "returns an empty array" do
        expect(subject).to eq expected_output
      end
    end
  end
end
