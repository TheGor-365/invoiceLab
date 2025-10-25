class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = current_user.clients.order(:name)
  end

  def show; end

  def new
    @client = current_user.clients.new(
      locale: current_user.locale,
      timezone: current_user.timezone,
      currency: current_user.default_currency
    )
  end

  def edit; end

  def create
    @client = current_user.clients.new(client_params)
    if @client.save
      redirect_to @client, notice: t("clients.flash.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: t("clients.flash.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @client.destroy
      redirect_to clients_url, notice: t("clients.flash.destroyed")
    else
      redirect_to @client, alert: @client.errors.full_messages.to_sentence
    end
  end

  private

  def set_client
    @client = current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email, :locale, :timezone, :currency, :note)
  end
end
