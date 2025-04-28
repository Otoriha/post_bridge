class User < ApplicationRecord
    has_secure_password validations: false

    has_many :authentications, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :post_templates, dependent: :destroy

    validates :email, uniqueness: true
end
