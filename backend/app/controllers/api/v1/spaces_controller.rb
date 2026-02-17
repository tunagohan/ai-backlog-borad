module Api
  module V1
    class SpacesController < ApplicationController
      def index
        store = Store.find(params[:store_id])
        spaces = store.spaces.order(:id)
        render json: spaces.map { |space| space_payload(space) }
      end

      def create
        store = Store.find(params[:store_id])
        space = store.spaces.create!(space_params)
        render json: space_payload(space), status: :created
      end

      private

      def space_params
        params.require(:space).permit(:name, :floor_label)
      end

      def space_payload(space)
        {
          id: space.id,
          store_id: space.store_id,
          name: space.name,
          floor_label: space.floor_label,
          created_at: space.created_at,
          updated_at: space.updated_at
        }
      end
    end
  end
end
