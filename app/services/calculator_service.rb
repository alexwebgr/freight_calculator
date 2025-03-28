# frozen_string_literal: true

require_relative "input_parser_service"
require_relative "map_reduce_service"

class CalculatorService
  attr_reader :input_string
  attr_reader :aggregated_sailings
  attr_reader :origin_port
  attr_reader :destination_port

  def self.call(input_string)
    new(input_string).call
  end

  def initialize(input_string)
    @input_string = input_string
  end

  def call
    @origin_port, @destination_port, criteria = InputParserService.call(input_string).values

    return [] if criteria_methods[criteria].nil?

    @aggregated_sailings = MapReduceService.call

    sailing_codes = send criteria_methods[criteria]
    find_sailings(sailing_codes)
  end

  def criteria_methods
    raise NotImplementedError, "Class must implement criteria_methods"
  end
end
