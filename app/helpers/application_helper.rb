module ApplicationHelper
  # Короткий хелпер для цветных бейджей статуса инвойса
  def status_badge(status)
    key = status.to_s
    text = I18n.t("invoices.statuses.#{key}", default: key.humanize)

    color = case key
            when "draft"   then "secondary"
            when "sent"    then "info"
            when "paid"    then "success"
            when "overdue" then "danger"
            when "canceled" then "dark"
            else "secondary"
            end

    content_tag(:span, text, class: "badge bg-#{color}")
  end
end
