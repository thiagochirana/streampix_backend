class CreateDonateConfigurations < ActiveRecord::Migration[8.0]
  def change
    create_table :donate_configurations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :alert_access_key, null: false

      t.timestamps
    end
    add_index :donate_configurations, :alert_access_key, unique: true
  end
end
