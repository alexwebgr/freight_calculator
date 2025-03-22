require_relative "../payload"

class MapReduceService
  include Payload

  def self.call
    new.call
  end

  def call
    rates = PAYLOAD[:rates].each_with_object({}) do |rate, memo|
      memo[rate[:sailing_code]] = rate
    end

    PAYLOAD[:sailings].map do |sailing|
      {}.merge(sailing, rates[sailing[:sailing_code]]) if rates[sailing[:sailing_code]]
    end.compact
  end
end
