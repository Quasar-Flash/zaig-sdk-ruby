# frozen_string_literal: true

require "singleton"

module Zaig
  # Service class to build a registration payload request.
  class RegistrationPayload
    include Singleton

    def call(obj)
      {
        address: build_address(obj[:address]),
        client_category: obj[:client_category],
        constitution_date: obj[:constitution_date],
        constitution_type: obj[:constitution_type],
        credit_request_date: obj[:credit_request_date],
        credit_type: obj[:credit_type] || "clean",
        document_number: CNPJ.new(obj[:document_number]).formatted,
        email: obj[:email],
        financial: obj.key?("financial") ? build_financial(obj[:financial]) : nil,
        guarantors: obj.key?("guarantors") ? build_shareholders(obj[:guarantors]) : nil,
        id: obj[:id],
        legal_name: obj[:legal_name],
        monthly_revenue: format_money(obj[:monthly_revenue], require_positive: true),
        phones: build_phones(obj[:phones]),
        shareholders: build_shareholders(obj[:shareholders]),
        source: obj.key?("source") ? build_source(obj[:source]) : nil,
        scr_parameters: obj.key?("scr_parameters") ? build_scr_parameters(obj[:scr_parameters]) : nil,
        trading_name: obj[:trading_name],
        warrants: obj.key?("warrants") ? build_warrants(obj[:warrants]) : nil
      }
    end

    private
      def format_money(value, require_positive: false)
        return 1.0 if require_positive && !value.to_f.positive?

        value.to_f
      rescue StandardError
        require_positive ? 1.0 : 0.0
      end

      def build_address(obj_address)
        {
          city: obj_address[:city],
          complement: obj_address[:complement] || "",
          country: obj_address[:country] || "BRA",
          neighborhood: obj_address[:neighborhood],
          number: obj_address[:number],
          postal_code: format_cep(obj_address[:postal_code]),
          street: obj_address[:street],
          uf: obj_address[:uf]
        }
      end

      def build_phone(obj)
        {
          area_code: obj[:area_code],
          international_dial_code: obj[:international_dial_code],
          number: obj[:number],
          type: obj[:type]
        }
      end

      def build_phones(obj_phones)
        phones = []

        obj_phones.each { |p| phones << build_phone(p) }

        phones
      end

      def build_shareholders(obj_shareholders)
        return nil if obj_shareholders.nil?

        shareholders = []

        obj_shareholders.each do |s|
          shareholders << {
            address: build_address(s[:address]),
            birthdate: s[:birthdate],
            declared_assets: format_money(s[:declared_assets]),
            document_number: CPF.new(s[:document_number]).formatted,
            email: s[:email],
            father_name: s[:father_name],
            gender: s[:gender],
            monthly_income: format_money(s[:monthly_income]),
            mother_name: s[:mother_name],
            name: s[:name],
            nationality: s[:nationality],
            occupation: s[:occupation],
            phones: build_phones(s[:phones])
          }
        end
        shareholders
      end

      def build_financial(fin)
        return nil if fin.nil?

        {
          amount: fin[:amount],
          annual_interest_rate: fin[:annual_interest_rate],
          cdi_percentage: fin[:cdi_percentage],
          currency: fin[:currency] || "BRL",
          interest_type: fin[:interest_type],
          number_of_installments: fin.key?("number_of_installments") ? fin[:number_of_installments].to_i : 0
        }
      end

      def build_warrants(obj_warrants)
        return nil if obj_warrants.nil?

        warrants = []

        obj_warrants.each do |w|
          warrants << {
            warrant_type: w[:warrant_type],
            address: build_address(w[:address]),
            property_type: w[:property_type],
            estimated_value: w[:estimated_value],
            forced_selling_value: w[:forced_selling_value]
          }
        end
        warrants
      end

      def build_source(obj_source)
        return nil if obj_source.nil?

        {
          channel: obj_source[:channel],
          ip: obj_source[:ip],
          session_id: obj_source[:session_id]
        }
      end

      def build_scr_parameters(obj_src)
        return nil if obj_src.nil?

        {
          signers: build_signers(obj_src[:signers]),
          signature_evidence: {
            access_token: obj_src[:signature_evidence][:access_token],
            additional_data: obj_src[:signature_evidence][:additional_data],
            ip_address: obj_src[:signature_evidence][:ip_address],
            session_id: obj_src[:signature_evidence][:session_id],
            signed_term: {
              raw_text: obj_src[:signature_evidence][:signed_term][:raw_text]
            }
          }
        }
      end

      def build_signers(obj_signers)
        return nil if obj_signers.nil?

        signers = []
        obj_signers.each do |s|
          signers << {
            document_number: CNPJ.new(s[:document_number]).number,
            name: s[:name],
            email: s[:email],
            phone: build_phone(s[:phone])
          }
        end
        signers
      end

      def format_cep(cep)
        cep.gsub(/[^0-9]/, "").insert(5, "-")
      end
  end
end
