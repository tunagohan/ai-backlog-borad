module Api
  module V1
    class HealthController < ApplicationController
      def show
        ActiveRecord::Base.connection.execute("SELECT 1")

        render json: {
          status: "ok",
          service: "backend-api",
          timestamp: Time.current
        }
      rescue StandardError => error
        render json: {
          status: "degraded",
          service: "backend-api",
          error: error.class.name,
          message: error.message,
          timestamp: Time.current
        }, status: :service_unavailable
      end
    end
  end
end
