# frozen_string_literal: true

class InputParserService
  attr_reader :input_string

  def self.call(input_string)
    new(input_string).call
  end

  def initialize(input_string)
    @input_string = input_string
  end

  def call
    parse_string
  end

  private

  def parse_string
    return {} if input_string.nil?

    origin_port, destination_port, criteria = input_string.split("\n").map(&:strip)

    return {} if origin_port.nil? || destination_port.nil? || criteria.nil?

    {
      origin_port: origin_port,
      destination_port: destination_port,
      criteria: criteria
    }
  end
end
