class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :clients, dependent: :destroy
  has_many :invoices, dependent: :destroy

  validates :locale, inclusion: { in: %w[en ru es] }
  validates :timezone, presence: true
  validates :default_currency, presence: true
end
