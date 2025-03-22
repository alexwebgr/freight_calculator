require_relative "services/map_reduce_service"
require_relative "services/input_parser_service"

module Finder
  attr_reader :input_string
  attr_reader :aggregated_sailings
  attr_reader :origin_port
  attr_reader :destination_port

  def call
    @origin_port, @destination_port, criteria = InputParserService.call(input_string).values

    return [] if criteria_methods[criteria].nil?

    @aggregated_sailings = MapReduceService.new.aggregated_sailings

    sailing_codes = send criteria_methods[criteria]
    find_sailings(sailing_codes)
  end

  def find_sailings(codes)
    aggregated_sailings.select do |sailing|
      codes.include?(sailing[:sailing_code])
    end
  end

  def criteria_methods
    raise NotImplementedError, "Class must implement criteria_methods"
  end
end
