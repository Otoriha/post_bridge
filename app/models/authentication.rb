class Authentication < ApplicationRecord
    belongs_to :user
    has_many :post_deliveries

    validates :provider, presence: true
    validates :uid, presence: true, uniqueness: { scope: :provider }
  end
