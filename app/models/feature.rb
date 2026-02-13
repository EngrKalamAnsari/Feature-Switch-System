class Feature < ApplicationRecord
  has_many :feature_overrides, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :enabled, inclusion: { in: [true, false] }
  validates :description, length: { maximum: 255 }, allow_nil: true
end
