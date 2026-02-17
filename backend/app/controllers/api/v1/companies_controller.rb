module Api
  module V1
    class CompaniesController < ApplicationController
      def create
        company = Company.create!(company_params)
        render json: company_payload(company), status: :created
      end

      def show
        company = Company.find(params[:id])
        render json: company_payload(company)
      end

      private

      def company_params
        params.require(:company).permit(:name)
      end

      def company_payload(company)
        {
          id: company.id,
          name: company.name,
          created_at: company.created_at,
          updated_at: company.updated_at
        }
      end
    end
  end
end
