class FeatureOverride < ApplicationRecord
  belongs_to :feature
  belongs_to :user, optional: true   
  belongs_to :group, optional: true  

  validates :enabled, inclusion: { in: [true, false] }
  validates :region, length: { maximum: 50 }, allow_nil: true
end
