class Post < ApplicationRecord

  validates :title, :description, presence: true

  belongs_to :user

  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true
end
