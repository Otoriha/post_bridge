class Post < ApplicationRecord
    belongs_to :user
    belongs_to :post_template, optional: true
    has_many :post_deliveries, dependent: :destroy

    validates :status, presence: true

    enum status: {
      draft: "draft",
      published: "published"
    }
  end
