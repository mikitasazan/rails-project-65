# frozen_string_literal: true

class Bulletin < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  belongs_to :category

  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, attached: true, content_type: %i[png jpg jpeg], size: { less_than: 5.megabytes }

  include AASM

  aasm column: :state do
    state :draft, initial: true
    state :under_moderation, :rejected, :archived, :published

    event :to_moderate do
      transitions from: :draft, to: :under_moderation
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[under_moderation rejected draft published], to: :archived
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at description id state title updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end

  scope :published, -> { where(state: :published) }
end
