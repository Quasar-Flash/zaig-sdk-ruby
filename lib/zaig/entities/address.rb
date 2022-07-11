# frozen_string_literal: true

class Address
  attr_accessor :city, :complement, :country, :neighborhood, :number, :postal_code, :street, :uf

  def initialize(city:, neighborhood:, number:, postal_code:, street:, uf:, complement: nil, country: "BRA")
    @city = city
    @complement = complement
    @country = country
    @neighborhood = neighborhood
    @number = number
    @postal_code = postal_code
    @street = street
    @uf = uf
  end
end
