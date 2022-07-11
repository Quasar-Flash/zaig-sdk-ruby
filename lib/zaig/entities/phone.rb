# frozen_string_literal: true

class Phone
  attr_accessor :area_code, :international_dial_code, :number, :type

  enum type: { commercial: 0, mobile: 1, residential: 2 }

  def initialize(area_code:, number:, type:, international_dial_code: "55")
    @area_code = area_code
    @international_dial_code = international_dial_code
    @number = number
    @type = type
  end
end
