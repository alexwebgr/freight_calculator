# frozen_string_literal: true

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

    @aggregated_sailings = MapReduceService.call

    sailing_codes = send criteria_methods[criteria]
    find_sailings(sailing_codes)
  end

  def find_sailings(codes)
    aggregated_sailings.select do |sailing|
      codes.include?(sailing[:sailing_code])
    end
  end

  def first_legs
    sailings_by_origin = aggregated_sailings.group_by { |sailing| sailing[:origin_port] }

    sailings_by_origin[origin_port] || []
  end

  def second_legs
    sailings_by_departure = aggregated_sailings.group_by { |sailing| sailing[:destination_port] }

    sailings_by_departure[destination_port] || []
  end

  def eligible_leg?(first_leg, second_leg)
    first_leg[:destination_port] == second_leg[:origin_port] &&
      Date.parse(first_leg[:arrival_date]) <= Date.parse(second_leg[:departure_date])
  end

  def criteria_methods
    raise NotImplementedError, "Class must implement criteria_methods"
  end
end
