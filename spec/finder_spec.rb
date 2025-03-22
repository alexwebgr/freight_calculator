# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../app/finder"

describe Finder do
  describe "#criteria_methods" do
    it "raises an exception" do
      expect { MyClass.call("") }.to raise_error(NotImplementedError)
    end
  end
end

class MyClass
  include Finder

  def self.call(input_string)
    new(input_string).call
  end

  def initialize(input_string)
    @input_string = input_string
  end
end
