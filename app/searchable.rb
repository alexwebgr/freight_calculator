# frozen_string_literal: true

module Searchable
  def find_sailings(codes)
    aggregated_sailings.select do |sailing|
      codes.include?(sailing[:sailing_code])
    end
  end

  def first_legs
    sailings_by_origin = aggregated_sailings.group_by { |sailing| sailing[:origin_port] }
    sailings_by_origin[origin_port] || []
  end

  def second_legs
    sailings_by_departure = aggregated_sailings.group_by { |sailing| sailing[:destination_port] }
    sailings_by_departure[destination_port] || []
  end

  def eligible_leg?(first_leg, second_leg)
    first_leg[:destination_port] == second_leg[:origin_port] &&
      Date.parse(first_leg[:arrival_date]) <= Date.parse(second_leg[:departure_date])
  end
end
