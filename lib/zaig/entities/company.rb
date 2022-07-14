# frozen_string_literal: true

class Company
  attr_accessor :address, :client_category, :constitution_date, :constitution_type,
                :document_number, :email, :financial, :guarantors,
                :id, :legal_name, :monthly_revenue, :phones, :shareholders, :source,
                :scr_parameters, :trading_name, :warrants

  enum client_category: { cedente: 0, sacado: 1 }

  enum constitution_type: { llc: 0, corp: 1 }

  enum credit_type: { clean: 0, credit_card_limit: 1, student_loan: 2 }
end
