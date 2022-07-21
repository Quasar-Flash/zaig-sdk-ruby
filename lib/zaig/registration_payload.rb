# frozen_string_literal: true

module Zaig
  # Service class to build a registration payload request.
  class RegistrationPayload
    include Singleton

    def call(obj)
      payload = {
        client_category: obj[:client_category],
        credit_request_date: obj[:credit_request_date],
        credit_type: obj[:credit_type] || "clean",
        document_number: CNPJ.new(obj[:document_number]).formatted,
        id: obj[:id],
        legal_name: obj[:legal_name],
        monthly_revenue: format_money(obj[:monthly_revenue], require_positive: true),
        trading_name: obj[:trading_name]
      }
      payload[:address] = build_address(obj[:address]) if obj[:address]
      payload[:constitution_date] = obj[:constitution_date] if obj[:constitution_date]
      payload[:constitution_type] = obj[:constitution_type] if obj[:constitution_type]
      payload[:email] = obj[:email] if obj[:email]
      payload[:financial] = build_financial(obj[:financial]) if obj[:financial]
      payload[:guarantors] = build_shareholders(obj[:guarantors]) if obj[:guarantors]
      payload[:phones] = build_phones(obj[:phones]) if obj[:phones]
      payload[:scr_parameters] = build_scr_parameters(obj[:scr_parameters]) if obj[:scr_parameters]
      payload[:shareholders] = build_shareholders(obj[:shareholders]) if obj[:shareholders]
      payload[:source] = build_source(obj[:source]) if obj[:source]
      payload[:warrants] = build_warrants(obj[:warrants]) if obj[:warrants]
      payload
    end

    private
      def format_money(value, require_positive: false)
        require_positive && !value.to_f.positive? ? 1.0 : value.to_f
      end

      def build_address(obj_address)
        address = {
          city: obj_address[:city],
          country: obj_address[:country] || "BRA",
          neighborhood: obj_address[:neighborhood],
          number: obj_address[:number],
          postal_code: format_cep(obj_address[:postal_code]),
          street: obj_address[:street],
          uf: obj_address[:uf]
        }
        address[:complement] = obj_address[:complement] if !obj_address[:complement].nil? || !obj_address[:complement]&.empty?
        address
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
            father_name: filter_blank(s[:father_name]),
            gender: s[:gender],
            monthly_income: format_money(s[:monthly_income]),
            mother_name: filter_blank(s[:mother_name]),
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

      def filter_blank(value)
        return value if value.nil?

        value.strip == "" ? nil : value
      end

      def format_cep(cep)
        cep = cep.delete("-")
        cep.gsub(/[^0-9]/, "").insert(5, "-")
      end
  end
end
