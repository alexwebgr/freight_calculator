require_relative "../spec_helper"
require_relative "../../app/services/map_reduce_service"

describe MapReduceService do
  subject { MapReduceService.new }
  describe "#raw" do
    it "returns the data as is" do
      expect(subject.raw).to eq(described_class::PAYLOAD)
    end
  end

  describe "#exchange_rates" do
    it "returns the data as is" do
      expect(subject.exchange_rates).to eq(described_class::PAYLOAD[:exchange_rates])
    end
  end

  describe "#aggregated_sailings" do
    it "returns the sailings along with the rates" do
      # only check the first entry for structural correctness
      expect(subject.aggregated_sailings[0]).to eq({
        "origin_port": "CNSHA",
        "destination_port": "NLRTM",
        "departure_date": "2022-02-01",
        "arrival_date": "2022-03-01",
        "sailing_code": "ABCD",
        "rate": "589.30",
        "rate_currency": "USD"
      })
    end
  end
end
