# frozen_string_literal: true

require "date"
require_relative "calculator_service"
require_relative "../searchable"
require_relative "../payload"

class CheapestCalculatorService < CalculatorService
  CONVERSION_CURRENCY = "EUR"

  include Searchable
  include Payload

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
    default_entry = { rate: Float::INFINITY }

    aggregated_sailings.map do |sailing|
      next unless sailing[:origin_port] == origin_port &&
                  sailing[:destination_port] == destination_port &&
                  exchange_rate_available?(sailing)

      sailing.merge(rate: calculate_rate(sailing))
    end.compact.min_by { |entry| entry[:rate] } || default_entry
  end

  def cheapest_indirect_route
    default_entry = { sailing_codes: [], total_cost: Float::INFINITY }

    first_legs.flat_map do |first_leg|
      next unless exchange_rate_available?(first_leg)

      calculate_total_cost(first_leg)
    end.compact.min_by { |entry| entry[:total_cost] } || default_entry
  end

  def calculate_total_cost(first_leg)
    second_legs.map do |second_leg|
      next unless eligible_leg?(first_leg, second_leg) && exchange_rate_available?(second_leg)

      {
        sailing_codes: [first_leg[:sailing_code], second_leg[:sailing_code]],
        total_cost: calculate_rate(first_leg) + calculate_rate(second_leg)
      }
    end.compact
  end

  def calculate_rate(sailing)
    return sailing[:rate].to_f.round(2) if sailing[:rate_currency] == CONVERSION_CURRENCY

    exchange_rate = exchange_rates[sailing[:departure_date].to_sym][sailing[:rate_currency].downcase.to_sym]
    (exchange_rate * sailing[:rate].to_f).round(2)
  end

  def exchange_rate_available?(sailing)
    return true if sailing[:rate_currency] == CONVERSION_CURRENCY
    return false if exchange_rates[sailing[:departure_date].to_sym].nil? ||
                    exchange_rates[sailing[:departure_date].to_sym][sailing[:rate_currency].downcase.to_sym].nil?

    true
  end
end
