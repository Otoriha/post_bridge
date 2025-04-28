class PostDelivery < ApplicationRecord
    belongs_to :post
    belongs_to :authentication

    validates :status, presence: true

    enum status: {
      pending: "pending",
      processing: "processing",
      completed: "completed",
      failed: "failed"
    }
  end
