# frozen_string_literal: true

require "date"
require_relative "../searchable"
require_relative "../payload"

class CheapestCalculatorService
  include Searchable
  include Payload

  def self.call(input_string)
    new(input_string).call
  end

  def initialize(input_string)
    @input_string = input_string
  end

  def criteria_methods
    {
      "cheapest-direct" => "cheapest_direct",
      "cheapest" => "cheapest"
    }
  end

  private

  def cheapest_direct
    [cheapest_direct_route[:sailing_code]]
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

  def cheapest_direct_route
    aggregated_sailings.map do |sailing|
      if sailing[:origin_port] == origin_port && sailing[:destination_port] == destination_port
        sailing.merge(rate: calculate_rate(sailing))
      end
    end
      .compact
      .min_by { |entry| entry[:rate] } || {}
  end

  def cheapest_indirect_route
    first_legs.flat_map do |first_leg|
      second_legs.map do |second_leg|
        next unless eligible_leg?(first_leg, second_leg)

        {
          sailing_codes: [first_leg[:sailing_code], second_leg[:sailing_code]],
          total_cost: calculate_rate(first_leg) + calculate_rate(second_leg)
        }
      end.compact
    end.min_by { |entry| entry[:total_cost] } || {}
  end

  def calculate_rate(sailing, conversion_currency = "EUR")
    return sailing[:rate].to_f.round(2) if sailing[:rate_currency] == conversion_currency

    exchange_rate = exchange_rates[sailing[:departure_date].to_sym][sailing[:rate_currency].downcase.to_sym]
    (exchange_rate * sailing[:rate].to_f).round(2)
  end
end
