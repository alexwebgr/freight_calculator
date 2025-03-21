require "date"
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
    criteria_methods = {
      "cheapest-direct" => "cheapest_direct",
      "cheapest" => "cheapest",
    }

    return [] if criteria_methods[criteria].nil?

    @aggregated_sailings = MapReduceService.new.aggregated_sailings

    sailing_codes = send criteria_methods[criteria]
    find_sailings(sailing_codes)
  end

  private

  def find_sailings(codes)
    aggregated_sailings.select do |sailing|
      codes.include?(sailing[:sailing_code])
    end
  end

  def cheapest
    cheapest_direct = cheapest_direct_route
    cheapest_indirect = cheapest_indirect_route

    if cheapest_indirect[:total_cost] == cheapest_direct[:rate]
      [cheapest_indirect[:sailing_codes], cheapest_direct[:sailing_code]].flatten
    elsif cheapest_indirect[:total_cost] > cheapest_direct[:rate]
      cheapest_direct[:sailing_code]
    else
      cheapest_indirect[:sailing_codes]
    end
  end

  def cheapest_indirect_route
    sailings_by_origin = aggregated_sailings.group_by { |sailing| sailing[:origin_port] }
    sailings_by_departure = aggregated_sailings.group_by { |sailing| sailing[:destination_port] }

    first_legs = sailings_by_origin[origin_port] || []
    second_legs = sailings_by_departure[destination_port] || []

    first_legs.flat_map do |first_leg|
      second_legs.map do |second_leg|
        if first_leg[:destination_port] == second_leg[:origin_port] && Date.parse(first_leg[:arrival_date]) <= Date.parse(second_leg[:departure_date])
          {
            sailing_codes: [first_leg[:sailing_code], second_leg[:sailing_code]],
            total_cost: calculate_rate(first_leg) + calculate_rate(second_leg)
          }
        end
      end.compact
    end
      .min_by { |entry| entry[:total_cost] }
  end

  def cheapest_direct
    [cheapest_direct_route[:sailing_code]]
  end

  def cheapest_direct_route
    aggregated_sailings
      .map do |sailing|
        if sailing[:origin_port] == origin_port && sailing[:destination_port] == destination_port
          sailing.merge(rate: calculate_rate(sailing))
        end
      end
      .compact
      .min_by { |entry| entry[:rate] }
  end

  def calculate_rate(sailing, conversion_currency = "EUR")
    return sailing[:rate].to_f.round(2) if sailing[:rate_currency] == conversion_currency

    exchange_rate = MapReduceService.new.exchange_rates[sailing[:departure_date].to_sym][sailing[:rate_currency].downcase.to_sym]
    (exchange_rate * sailing[:rate].to_f).round(2)
  end
end
