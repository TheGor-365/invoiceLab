class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :locale, inclusion: { in: %w[en ru es] }
  validates :timezone, presence: true
  validates :default_currency, presence: true
end
