class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  before_validation :compute_total

  validates :name, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }

  private

  def compute_total
    self.total_cents = (quantity.to_d * unit_price_cents.to_i).to_i
  end
end
