# frozen_string_literal: true

require_relative "../spec_helper"
require_relative "../../app/services/map_reduce_service"

describe MapReduceService do
  subject { MapReduceService.new }

  describe "#aggregated_sailings" do
    it "returns the sailings along with the rates" do
      # only check the first entry for structural correctness
      expect(subject.call[0]).to eq({
                                      origin_port: "CNSHA",
                                      destination_port: "NLRTM",
                                      departure_date: "2022-02-01",
                                      arrival_date: "2022-03-01",
                                      sailing_code: "ABCD",
                                      rate: "589.30",
                                      rate_currency: "USD"
                                    })
    end

    context "when a rate doesn't exist for a sailing" do
      it "returns only the ones with rates" do
        stub_const("MapReduceService::PAYLOAD", file_fixture("sailings_1.json"))
        expect(subject.call).to eq([
                                     {
                                       arrival_date: "2022-03-05",
                                       departure_date: "2022-01-30",
                                       destination_port: "NLRTM",
                                       origin_port: "CNSHA",
                                       rate: "589.30",
                                       rate_currency: "USD",
                                       sailing_code: "MNOA"
                                     }
                                   ])
      end
    end
  end
end
