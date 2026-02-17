module Api
  module V1
    class StoresController < ApplicationController
      def index
        property = Property.find(params[:property_id])
        stores = property.stores.order(:id)
        render json: stores.map { |store| store_payload(store) }
      end

      def create
        property = Property.find(params[:property_id])
        store = property.stores.create!(store_params)
        render json: store_payload(store), status: :created
      end

      private

      def store_params
        params.require(:store).permit(:name)
      end

      def store_payload(store)
        {
          id: store.id,
          property_id: store.property_id,
          name: store.name,
          created_at: store.created_at,
          updated_at: store.updated_at
        }
      end
    end
  end
end
