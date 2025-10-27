# frozen_string_literal: true
module Reminders
  class SweepJob < ApplicationJob
    queue_as :default

    TARGET_HOUR = 9 # локальное время клиента

    def perform
      due_candidates = 0
      overdue_candidates = 0
      enqueued = 0

      # В enum нет статуса :due — работаем со «sent» и «overdue»
      Invoice.includes(:client, :user).where(status: [:sent, :overdue]).find_each do |inv|
        tz = inv.client&.timezone.presence || "UTC"
        Time.use_zone(tz) do
          now = Time.zone.now
          next unless now.hour == TARGET_HOUR
          next unless inv.due_date.present?

          # Reminder «due» в день срока (статус не меняем)
          if now.to_date == inv.due_date && inv.status_sent?
            due_candidates += 1
            enqueued += 1 if enqueue_once(inv, "due")
          end

          # «overdue» на следующий день после срока (и статус проставляем)
          if now.to_date == inv.due_date + 1.day && !inv.status_paid? && !inv.status_canceled?
            overdue_candidates += 1
            enqueued += 1 if enqueue_once(inv, "overdue")
            inv.update!(status: :overdue) unless inv.status_overdue?
          end
        end
      end

      Rails.logger.info("Reminders::SweepJob: due_candidates=#{due_candidates} overdue_candidates=#{overdue_candidates} enqueued=#{enqueued}")
    end

    private

    # Вернёт true, если реально поставили в очередь (не было дубликата)
    def enqueue_once(invoice, kind)
      dup_guard = EmailLog.where(invoice: invoice, kind: kind, status: [:queued, :sent])
                          .where("created_at > ?", 2.days.ago)
                          .exists?
      return false if dup_guard

      SendInvoiceEmailJob.perform_later(invoice.id, kind)
      true
    end
  end
end
