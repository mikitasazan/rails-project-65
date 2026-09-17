# frozen_string_literal: true

class Bulletin < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  belongs_to :category

  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, attached: true, content_type: %i[png jpg jpeg], size: { less_than: 5.megabytes }

  enum :state, { draft: "draft", under_moderation: "under_moderation", published: "published",
                 rejected: "rejected", archived: "archived" }, prefix: true

  scope :published, -> { where(state: :published) }
end
