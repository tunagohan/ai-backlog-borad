module Api
  module V1
    class IssuesController < ApplicationController
      def index
        issues = Issue.where(company_id: params[:company_id])
                      .order(reported_at: :desc)

        issues = issues.where(status: params[:status]) if params[:status].present?
        render json: issues.map { |issue| issue_payload(issue) }
      end

      def create
        issue = Issue.new(issue_params.except(:image_urls).merge(reported_at: Time.current))
        issue.image_urls_array = issue_params[:image_urls]
        issue.save!
        create_notification_for_issue(issue, "created")
        record_audit!(
          company_id: issue.company_id,
          action: "issue_reported",
          resource_type: "issue",
          resource_id: issue.id,
          metadata: { severity: issue.severity, status: issue.status }
        )
        render json: issue_payload(issue), status: :created
      end

      def update
        issue = Issue.find(params[:id])
        attrs = update_params.except(:image_urls)
        issue.assign_attributes(attrs)
        issue.image_urls_array = update_params[:image_urls] if update_params.key?(:image_urls)
        issue.save!
        issue.update!(resolved_at: Time.current) if issue.closed? && issue.resolved_at.nil?
        create_notification_for_issue(issue, "updated")
        record_audit!(
          company_id: issue.company_id,
          action: "issue_updated",
          resource_type: "issue",
          resource_id: issue.id,
          metadata: { severity: issue.severity, status: issue.status }
        )
        render json: issue_payload(issue)
      end

      private

      def issue_params
        params.require(:issue).permit(:company_id, :job_id, :title, :description, :severity, image_urls: [])
      end

      def update_params
        params.require(:issue).permit(:status, :severity, :title, :description, image_urls: [])
      end

      def issue_payload(issue)
        {
          id: issue.id,
          company_id: issue.company_id,
          job_id: issue.job_id,
          title: issue.title,
          description: issue.description,
          image_urls: issue.image_urls_array,
          severity: issue.severity,
          status: issue.status,
          reported_at: issue.reported_at,
          resolved_at: issue.resolved_at,
          created_at: issue.created_at,
          updated_at: issue.updated_at
        }
      end

      def create_notification_for_issue(issue, action)
        level = issue.severity == "high" ? :critical : :warning
        Notification.create!(
          company_id: issue.company_id,
          level: level,
          title: "Issue #{action}",
          message: "Issue ##{issue.id} (#{issue.title}) was #{action}.",
          resource_type: "issue",
          resource_id: issue.id
        )
      end
    end
  end
end
