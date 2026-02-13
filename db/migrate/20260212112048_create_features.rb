class CreateFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :features do |t|
      t.string :name
      t.boolean :enabled
      t.text :description

      t.timestamps
    end
  end
end
