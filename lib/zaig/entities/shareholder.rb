# frozen_string_literal: true

class Shareholder
  attr_accessor :address, :birthdate, :declared_assets, :document_number, :email, :fathername, :gender,
                :mothername, :monthly_income, :name, :nationality, :occupation, :phone

  enum gender: { male: 0, female: 1, undefined: 2 }
end
