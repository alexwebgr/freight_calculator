require "time"
require_relative "../finder"

class FastestCalculatorService
  include Finder

  def self.call(input_string)
    new(input_string).call
  end

  def initialize(input_string)
    @input_string = input_string
  end

  def criteria_methods
    {
      "fastest-direct" => "fastest_direct",
      "fastest" => "fastest",
    }
  end

  private

  def fastest
    fastest_direct = fastest_direct_route
    fastest_indirect = fastest_indirect_route

    if fastest_indirect[:total_duration] == fastest_direct[:total_duration]
      [fastest_indirect[:sailing_codes], fastest_direct[:sailing_code]].flatten
    elsif fastest_indirect[:total_duration] > fastest_direct[:total_duration]
      fastest_direct[:sailing_code]
    else
      fastest_indirect[:sailing_codes]
    end
  end

  def fastest_indirect_route
    sailings_by_origin = aggregated_sailings.group_by { |sailing| sailing[:origin_port] }
    sailings_by_departure = aggregated_sailings.group_by { |sailing| sailing[:destination_port] }

    first_legs = sailings_by_origin[origin_port] || []
    second_legs = sailings_by_departure[destination_port] || []

    first_legs.flat_map do |first_leg|
      second_legs.map do |second_leg|
        if first_leg[:destination_port] == second_leg[:origin_port] && Date.parse(first_leg[:arrival_date]) <= Date.parse(second_leg[:departure_date])
          {
            sailing_codes: [first_leg[:sailing_code], second_leg[:sailing_code]],
            total_duration: calculate_duration(first_leg) + calculate_duration(second_leg)
          }
        end
      end.compact
    end
      .min_by { |entry| entry[:total_duration] }
  end

  def fastest_direct
    [fastest_direct_route[:sailing_code]]
  end

  def fastest_direct_route
    aggregated_sailings
      .map do |sailing|
        if sailing[:origin_port] == origin_port && sailing[:destination_port] == destination_port
          sailing.merge(total_duration: calculate_duration(sailing))
        end
      end
      .compact
      .min_by { |entry| entry[:total_duration] }
  end

  def calculate_duration(sailing)
    Time.parse(sailing[:arrival_date]).to_i - Time.parse(sailing[:departure_date]).to_i
  end
end
