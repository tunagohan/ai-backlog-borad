module Api
  module V1
    class PropertiesController < ApplicationController
      def index
        company = Company.find(params[:company_id])
        properties = company.properties.order(:id)
        render json: properties.map { |property| property_payload(property) }
      end

      def create
        company = Company.find(params[:company_id])
        property = company.properties.create!(property_params)
        render json: property_payload(property), status: :created
      end

      private

      def property_params
        params.require(:property).permit(:name, :address)
      end

      def property_payload(property)
        {
          id: property.id,
          company_id: property.company_id,
          name: property.name,
          address: property.address,
          created_at: property.created_at,
          updated_at: property.updated_at
        }
      end
    end
  end
end
