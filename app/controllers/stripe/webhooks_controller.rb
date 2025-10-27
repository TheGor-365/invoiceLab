# frozen_string_literal: true
module Stripe
  class WebhooksController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def receive
      payload = request.raw_post
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      secret = ENV["STRIPE_WEBHOOK_SECRET"].to_s

      event = nil
      if secret.present?
        begin
          event = ::Stripe::Webhook.construct_event(payload, sig_header, secret)
        rescue JSON::ParserError => e
          Rails.logger.error("Stripe webhook JSON parse error: #{e.message}")
          return head :bad_request
        rescue ::Stripe::SignatureVerificationError => e
          Rails.logger.warn("Stripe signature verification failed: #{e.message}")
          return head :bad_request
        end
      else
        # Без проверки подписи (локальная отладка)
        event = JSON.parse(payload)
      end

      handle_event(event)
      head :ok
    end

    private

    def handle_event(event)
      type = event.is_a?(Hash) ? event["type"] : event.type
      obj  = event.is_a?(Hash) ? event["data"]["object"] : event.data.object

      case type
      when "checkout.session.completed"
        on_checkout_completed(obj)
      when "customer.subscription.updated", "customer.subscription.created"
        on_subscription_update(obj)
      when "customer.subscription.deleted"
        on_subscription_deleted(obj)
      else
        # no-op
      end
    end

    def on_checkout_completed(session_obj)
      mode = session_obj["mode"] || session_obj.mode
      metadata = session_obj["metadata"] || {}

      if mode == "payment" && metadata["invoice_id"].present?
        invoice = ::Invoice.find_by(id: metadata["invoice_id"])
        return unless invoice

        unless invoice.status_paid?
          invoice.mark_paid!
          SendInvoiceEmailJob.perform_later(invoice.id, "paid")
        end
      elsif mode == "subscription"
        user_id = metadata["user_id"]
        return unless user_id

        user = ::User.find_by(id: user_id)
        return unless user

        user.update!(
          stripe_customer_id: session_obj["customer"],
          stripe_subscription_id: session_obj["subscription"],
          subscription_status: "active",
          plan: ENV["STRIPE_PLAN_NAME"].presence || "pro"
        )
      end
    end

    def on_subscription_update(subscription_obj)
      user = ::User.find_by(stripe_customer_id: subscription_obj["customer"])
      return unless user
      user.update!(
        stripe_subscription_id: subscription_obj["id"],
        subscription_status: subscription_obj["status"]
      )
    end

    def on_subscription_deleted(subscription_obj)
      user = ::User.find_by(stripe_customer_id: subscription_obj["customer"])
      return unless user
      user.update!(subscription_status: "canceled")
    end
  end
end
