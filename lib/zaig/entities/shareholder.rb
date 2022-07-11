# frozen_string_literal: true

class Shareholder
  attr_accessor :address, :birthdate, :declared_assets, :document_number, :email, :fathername, :gender,
                :mothername, :monthly_income, :name, :nationality, :occupation, :phone

  enum gender: { male: 0, female: 1, undefined: 2 }

  def initialize(address:, birthdate:, document_number:, email:, name:, phone:, declared_assets: nil, fathername: nil,
                 gender: "undefined", mothername: nil, monthly_income: nil, nationality: "BRA", occupation: nil)
    @address = address
    @birthdate = birthdate
    @declared_assets = declared_assets
    @document_number = document_number
    @email = email
    @fathername = fathername
    @gender = gender
    @mothername = mothername
    @monthly_income = monthly_income
    @name = name
    @nationality = nationality
    @occupation = occupation
    @phone = phone
  end
end
