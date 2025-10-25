class Client < ApplicationRecord
  belongs_to :user
  has_many :invoices, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 160 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :locale, inclusion: { in: %w[en ru es] }
  validates :timezone, presence: true
  validates :currency, presence: true, length: { maximum: 6 }
end
