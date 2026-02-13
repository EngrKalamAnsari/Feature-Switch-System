class CreateFeatureOverrides < ActiveRecord::Migration[8.1]
  def change
    create_table :feature_overrides do |t|
      t.references :feature, null: false, foreign_key: true
      t.integer :user_id
      t.integer :group_id
      t.boolean :enabled

      t.timestamps
    end
  end
end
