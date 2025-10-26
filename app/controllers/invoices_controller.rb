class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :send_created, :send_due, :send_overdue, :send_paid]

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

  # ==== ручные отправки писем (итерация 2) ====
  def send_created
    InvoiceMailer.created(@invoice.id).deliver_later
    redirect_to @invoice, notice: t("invoices.flash.mail_sent", default: "Email scheduled to send")
  end

  def send_due
    InvoiceMailer.due(@invoice.id).deliver_later
    redirect_to @invoice, notice: t("invoices.flash.mail_sent", default: "Email scheduled to send")
  end

  def send_overdue
    InvoiceMailer.overdue(@invoice.id).deliver_later
    redirect_to @invoice, notice: t("invoices.flash.mail_sent", default: "Email scheduled to send")
  end

  def send_paid
    InvoiceMailer.paid(@invoice.id).deliver_later
    redirect_to @invoice, notice: t("invoices.flash.mail_sent", default: "Email scheduled to send")
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
