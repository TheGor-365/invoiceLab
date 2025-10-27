# frozen_string_literal: true

class SendInvoiceEmailJob < ApplicationJob
  queue_as :mailers

  # kind: "created" | "due" | "overdue" | "paid"
  def perform(invoice_id, kind)
    invoice = Invoice.find(invoice_id)

    # subject в логе — сразу на языке клиента
    subject_for_log = I18n.with_locale(invoice.client&.locale.presence || I18n.default_locale) do
      I18n.t("mailers.invoice.#{kind}.subject", number: invoice.number)
    end

    log = EmailLog.create!(
      user:    invoice.user,
      invoice: invoice,
      kind:    kind,
      to:      invoice.client.email,
      subject: subject_for_log,
      status:  :queued
    )

    mail = case kind.to_s
           when "created" then InvoiceMailer.created(invoice_id)
           when "due"     then InvoiceMailer.due(invoice_id)
           when "overdue" then InvoiceMailer.overdue(invoice_id)
           when "paid"    then InvoiceMailer.paid(invoice_id)
           else
             raise ArgumentError, "Unknown kind: #{kind}"
           end

    message = mail.deliver_now
    log.update!(status: :sent, message_id: (message&.message_id rescue nil), sent_at: Time.current)
  rescue => e
    log.update!(status: :failed, error: "#{e.class}: #{e.message}") if defined?(log) && log.present?
    raise
  end
end
