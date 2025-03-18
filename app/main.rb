require_relative "services/calculator_service"

pp CalculatorService.call(ENV["INPUT"])
