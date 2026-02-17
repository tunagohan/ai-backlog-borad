module Api
  module V1
    class NotificationsController < ApplicationController
      def index
        notifications = Notification.where(company_id: params[:company_id]).order(created_at: :desc)
        notifications = notifications.where(read_at: nil) if params[:unread] == "true"

        render json: notifications.map { |notification| notification_payload(notification) }
      end

      def update
        notification = Notification.find(params[:id])
        notification.update!(read_at: Time.current)
        render json: notification_payload(notification)
      end

      private

      def notification_payload(notification)
        {
          id: notification.id,
          company_id: notification.company_id,
          level: notification.level,
          title: notification.title,
          message: notification.message,
          resource_type: notification.resource_type,
          resource_id: notification.resource_id,
          read_at: notification.read_at,
          created_at: notification.created_at,
          updated_at: notification.updated_at
        }
      end
    end
  end
end
