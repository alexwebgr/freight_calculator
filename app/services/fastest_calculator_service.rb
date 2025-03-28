# frozen_string_literal: true

require "time"
require_relative "calculator_service"
require_relative "../searchable"

class FastestCalculatorService < CalculatorService
  include Searchable

  def criteria_methods
    {
      "fastest-direct" => "fastest_direct",
      "fastest" => "fastest"
    }
  end

  private

  def fastest_direct
    [fastest_direct_route[:sailing_code]]
  end

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

  def fastest_direct_route
    default_entry = { total_duration: Float::INFINITY }

    aggregated_sailings.map do |sailing|
      if sailing[:origin_port] == origin_port && sailing[:destination_port] == destination_port
        sailing.merge(total_duration: calculate_duration(sailing))
      end
    end
      .compact
      .min_by { |entry| entry[:total_duration] } || default_entry
  end

  def fastest_indirect_route
    default_entry = { sailing_codes: [], total_duration: Float::INFINITY }

    first_legs.flat_map do |first_leg|
      second_legs.map do |second_leg|
        next unless eligible_leg?(first_leg, second_leg)

        {
          sailing_codes: [first_leg[:sailing_code], second_leg[:sailing_code]],
          total_duration: calculate_duration(first_leg) + calculate_duration(second_leg)
        }
      end.compact
    end.min_by { |entry| entry[:total_duration] } || default_entry
  end

  def calculate_duration(sailing)
    Time.parse(sailing[:arrival_date]).to_i - Time.parse(sailing[:departure_date]).to_i
  end
end
