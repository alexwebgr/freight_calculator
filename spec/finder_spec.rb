require_relative "spec_helper"
require_relative "../app/finder"

describe Finder do
  describe "#criteria_methods" do
    class MyClass
      include Finder

      def self.call(input_string)
        new(input_string).call
      end

      def initialize(input_string)
        @input_string = input_string
      end
    end

    it "raises an exception" do
      expect { MyClass.call("") }.to raise_error(NotImplementedError)
    end
  end
end
