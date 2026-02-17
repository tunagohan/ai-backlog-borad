module Api
  module V1
    class AssetsController < ApplicationController
      def index
        space = Space.find(params[:space_id])
        assets = space.assets.order(:id)
        render json: assets.map { |asset| asset_payload(asset) }
      end

      def create
        space = Space.find(params[:space_id])
        asset = space.assets.create!(asset_params)
        render json: asset_payload(asset), status: :created
      end

      private

      def asset_params
        params.require(:asset).permit(:name, :category, :serial_number, :installed_on, :status)
      end

      def asset_payload(asset)
        {
          id: asset.id,
          space_id: asset.space_id,
          name: asset.name,
          category: asset.category,
          serial_number: asset.serial_number,
          installed_on: asset.installed_on,
          status: asset.status,
          created_at: asset.created_at,
          updated_at: asset.updated_at
        }
      end
    end
  end
end
