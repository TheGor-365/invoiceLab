# app/mailers/invoice_mailer.rb
class InvoiceMailer < ApplicationMailer
  default from: ENV.fetch("MAILER_FROM", "no-reply@example.com")

  def created(invoice_id)
    @invoice = Invoice.find(invoice_id)

    with_client_context(@invoice.client) do
      mail(
        to: @invoice.client.email,
        subject: I18n.t("mailers.invoice.created.subject", number: @invoice.number)
      )
    end
  end

  def due(invoice_id)
    @invoice = Invoice.find(invoice_id)

    with_client_context(@invoice.client) do
      mail(
        to: @invoice.client.email,
        subject: I18n.t("mailers.invoice.due.subject", number: @invoice.number)
      )
    end
  end

  def overdue(invoice_id)
    @invoice = Invoice.find(invoice_id)

    with_client_context(@invoice.client) do
      mail(
        to: @invoice.client.email,
        subject: I18n.t("mailers.invoice.overdue.subject", number: @invoice.number)
      )
    end
  end

  def paid(invoice_id)
    @invoice = Invoice.find(invoice_id)

    with_client_context(@invoice.client) do
      mail(
        to: @invoice.client.email,
        subject: I18n.t("mailers.invoice.paid.subject", number: @invoice.number)
      )
    end
  end

  private

  # Используем локаль и (опционально) таймзону клиента на время формирования письма.
  def with_client_context(client, &block)
    locale   = client&.locale.presence || I18n.default_locale
    timezone = client&.timezone.presence

    if timezone
      Time.use_zone(timezone) { I18n.with_locale(locale, &block) }
    else
      I18n.with_locale(locale, &block)
    end
  end
end
