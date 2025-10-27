class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @by_status      = current_user.invoices.group(:status).count
    @sum_by_status  = current_user.invoices.group(:status).sum(:total_cents)
    @emails_7d      = EmailLog.where(user: current_user).where("created_at >= ?", 7.days.ago).group(:status).count
  end
end
