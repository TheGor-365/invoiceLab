class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show, :edit, :update, :destroy,
                                     :send_created, :send_due, :send_overdue, :send_paid,
                                     :pay]

  def index
    # Сохраняем вашу выборку с includes(:client) и scope :recent
    @invoices = current_user.invoices.includes(:client).recent
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(@invoice).render
        send_data pdf,
          filename: "#{@invoice.number}.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  def new
    # Сохраняем ваши дефолты: client_id из params, валюта пользователя, +14 дней
    @invoice = current_user.invoices.new(
      client_id: params[:client_id],
      currency: current_user.default_currency,
      due_date: Date.current + 14.days
    )
    @invoice.invoice_items.build(name: "", quantity: 1, unit_price_cents: 0) if @invoice.invoice_items.empty?
  end

  def edit
    @invoice.invoice_items.build if @invoice.invoice_items.empty?
  end

  def create
    @invoice = current_user.invoices.new(invoice_params)
    if @invoice.save
      redirect_to @invoice, notice: t("invoices.flash.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: t("invoices.flash.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_url, notice: t("invoices.flash.destroyed")
  end

  # ==== ручные отправки писем (итерация 2/3) ====

  def send_created
    SendInvoiceEmailJob.perform_later(@invoice.id, "created")
    redirect_to @invoice, notice: t("common.enqueued")
  end

  def send_due
    SendInvoiceEmailJob.perform_later(@invoice.id, "due")
    redirect_to @invoice, notice: t("common.enqueued")
  end

  def send_overdue
    SendInvoiceEmailJob.perform_later(@invoice.id, "overdue")
    redirect_to @invoice, notice: t("common.enqueued")
  end

  def send_paid
    SendInvoiceEmailJob.perform_later(@invoice.id, "paid")
    redirect_to @invoice, notice: t("common.enqueued")
  end

  # ==== Stripe Checkout (оплата инвойса) ====
  # POST /invoices/:id/pay
  def pay
    return redirect_to @invoice, alert: t("payments.errors.already_paid") if @invoice.status_paid? || @invoice.status_canceled?

    base_url   = request.base_url
    success_url = "#{base_url}#{invoice_path(@invoice, locale: I18n.locale)}?paid=1"
    cancel_url  = "#{base_url}#{invoice_path(@invoice, locale: I18n.locale)}"

    session = Stripe::Checkout::Session.create(
      mode: "payment",
      success_url: success_url,
      cancel_url:  cancel_url,
      customer_email: @invoice.client.email,
      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: @invoice.currency.to_s.downcase,
            unit_amount: @invoice.total_cents,
            product_data: {
              name: I18n.t("payments.product_name", number: @invoice.number, default: "Invoice #{@invoice.number}")
            }
          }
        }
      ],
      metadata: {
        invoice_id: @invoice.id,
        user_id: current_user.id
      }
    )

    @invoice.update!(stripe_checkout_session_id: session.id, payment_url: session.url)
    redirect_to session.url, allow_other_host: true, status: :see_other
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe error: #{e.class}: #{e.message}")
    redirect_to @invoice, alert: t("payments.errors.checkout_failed")
  end

  private

  def set_invoice
    @invoice = current_user.invoices.find(params[:id])
  end

  def invoice_params
    # Сохраняем ваш permit (включая :number и :total_cents внутри items, чтобы не ломать формы/импорт)
    params.require(:invoice).permit(
      :client_id, :number, :status, :currency, :due_date, :issued_on, :notes,
      invoice_items_attributes: %i[id name description quantity unit_price_cents total_cents _destroy]
    )
  end
end
