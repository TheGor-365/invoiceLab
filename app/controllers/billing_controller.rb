# frozen_string_literal: true
class BillingController < ApplicationController
  before_action :authenticate_user!

  def pricing
  end

  # POST /billing/subscribe
  def subscribe
    price_id = params[:price].presence || ENV["STRIPE_PRICE_PRO"]
    raise "Missing STRIPE_PRICE_PRO" if price_id.blank?

    base_url   = request.base_url
    success_url = "#{base_url}#{billing_success_path(locale: I18n.locale)}"
    cancel_url  = "#{base_url}#{billing_cancel_path(locale: I18n.locale)}"

    session = Stripe::Checkout::Session.create(
      mode: "subscription",
      success_url: success_url,
      cancel_url:  cancel_url,
      customer_email: current_user.email,
      line_items: [{ price: price_id, quantity: 1 }],
      metadata: { user_id: current_user.id }
    )

    redirect_to session.url, allow_other_host: true, status: :see_other
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe subscribe error: #{e.class}: #{e.message}")
    redirect_to billing_path(locale: I18n.locale), alert: t("billing.flash.subscribe_failed")
  end

  # POST /billing/portal
  def portal
    unless current_user.stripe_customer_id.present?
      return redirect_to billing_path(locale: I18n.locale), alert: t("billing.flash.no_customer")
    end

    session = Stripe::BillingPortal::Session.create(
      customer: current_user.stripe_customer_id,
      return_url: billing_url(locale: I18n.locale)
    )
    redirect_to session.url, allow_other_host: true, status: :see_other
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe portal error: #{e.class}: #{e.message}")
    redirect_to billing_path(locale: I18n.locale), alert: t("billing.flash.portal_failed")
  end

  def success
    redirect_to billing_path(locale: I18n.locale), notice: t("billing.flash.subscribed")
  end

  def cancel
    redirect_to billing_path(locale: I18n.locale), alert: t("billing.flash.cancelled")
  end
end
