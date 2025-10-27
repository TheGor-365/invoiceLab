class EmailLog < ApplicationRecord
  enum status: { queued: 0, sent: 1, failed: 2 }

  belongs_to :user
  belongs_to :invoice

  scope :for_kind, ->(k) { where(kind: k) }
end
