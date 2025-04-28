class PostTemplate < ApplicationRecord
    belongs_to :user
    has_many :posts

    validates :name, presence: true
  end
