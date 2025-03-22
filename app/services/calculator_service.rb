# frozen_string_literal: true

require_relative "input_parser_service"
require_relative "cheapest_calculator_service"
require_relative "fastest_calculator_service"

class CalculatorService
  attr_reader :input_string

  def self.call(input_string)
    new(input_string).call
  end

  def initialize(input_string)
    @input_string = input_string
  end

  def call
    criteria = InputParserService.call(input_string)[:criteria]
    class_map = {
      "cheapest-direct" => "CheapestCalculatorService",
      "cheapest" => "CheapestCalculatorService",
      "fastest-direct" => "FastestCalculatorService",
      "fastest" => "FastestCalculatorService"
    }

    return [] if class_map[criteria].nil?

    Object.const_get(class_map[criteria]).call(input_string)
  end
end
