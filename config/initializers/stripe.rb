# frozen_string_literal: true

Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

# Опционально: дефолтный idempotency-key префикс для ActiveJob
Stripe.max_network_retries = 2
