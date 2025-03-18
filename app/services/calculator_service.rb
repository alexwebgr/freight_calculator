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
    @aggregated_sailings = MapReduceService.new.aggregated_sailings
    criteria_methods = {
      "cheapest-direct" => "cheapest_direct"
    }

    return [] if criteria_methods[criteria].nil?

    public_send criteria_methods[criteria]
  end

  def cheapest_direct
    aggregated_sailings
      .map do |sailing|
        if sailing[:origin_port] == origin_port && sailing[:destination_port] == destination_port
          sailing.merge(rate: calculate_rate(sailing), rate_currency: "EUR")
        end
      end
      .compact
      .min_by { |entry| entry[:rate] }
  end

  def calculate_rate(sailing)
    return sailing[:rate].to_f.round(2) if sailing[:rate_currency] == "EUR"

    exchange_rate = MapReduceService.new.exchange_rates[sailing[:departure_date].to_sym][sailing[:rate_currency].downcase.to_sym]
    (exchange_rate * sailing[:rate].to_f).round(2)
  end
end
