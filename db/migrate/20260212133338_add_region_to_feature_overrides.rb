class AddRegionToFeatureOverrides < ActiveRecord::Migration[8.1]
  def change
    add_column :feature_overrides, :region, :string
  end
end
