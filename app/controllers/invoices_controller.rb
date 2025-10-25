class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: %i[show edit update destroy]

  def index
    @invoices = current_user.invoices.includes(:client).recent
  end

  def show; end

  def new
    @invoice = current_user.invoices.new(
      client_id: params[:client_id],
      currency: current_user.default_currency,
      due_date: Date.current + 14.days
    )
    @invoice.invoice_items.build(name: "", quantity: 1, unit_price_cents: 0)
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

  private

  def set_invoice
    @invoice = current_user.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(
      :client_id, :number, :status, :currency, :due_date, :issued_on, :notes,
      invoice_items_attributes: %i[id name description quantity unit_price_cents total_cents _destroy]
    )
  end
end
