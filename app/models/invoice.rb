class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :invoice_items, dependent: :destroy
  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  enum :status, { draft: 0, sent: 1, paid: 2, overdue: 3, canceled: 4 }, prefix: true

  before_validation :assign_defaults
  before_validation :generate_number, if: -> { number.blank? }
  before_save :recompute_total

  validates :number, presence: true, uniqueness: { scope: :user_id }
  validates :currency, presence: true
  validates :due_date, presence: true
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }

  def mark_paid!(at: Time.current)
    update!(status: :paid, paid_at: at)
  end

  private

  def assign_defaults
    self.currency ||= client&.currency || user&.default_currency || "USD"
    self.issued_on ||= Date.current
  end

  def generate_number
    # Use absolute constant to avoid Invoice::Invoices lookup
    self.number = ::Invoices::NumberGenerator.next_for(user_id: user_id)
  end

  def recompute_total
    self.total_cents = invoice_items.map(&:total_cents).sum
  end
end
