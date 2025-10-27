module ApplicationHelper
  def status_badge(status)
    key  = status.to_s
    text = I18n.t("invoices.statuses.#{key}", default: key.humanize)

    color = case key
            when "draft"    then "secondary"
            when "sent"     then "info"
            when "paid"     then "success"
            when "overdue"  then "danger"
            when "canceled" then "dark"
            else "secondary"
            end

    content_tag(:span, text, class: "badge bg-#{color}")
  end
  
  def link_to_blank(name = nil, options = nil, html_options = nil, &block)
    html_options = (html_options || {}).deep_merge(
      target: "_blank",
      rel: "noopener noreferrer",
      data: { turbo: false }
    )
    link_to(name, options, html_options, &block)
  end
end
