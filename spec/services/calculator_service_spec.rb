# frozen_string_literal: true

require_relative "../spec_helper"
require_relative "../../app/services/calculator_service"

describe CalculatorService do
  describe "#criteria_methods" do
    context "when the class does not implement criteria_methods" do
      it "raises an exception" do
        expect { MyClass.call("") }.to raise_error(NotImplementedError)
      end
    end
  end
end

class MyClass < CalculatorService
end

