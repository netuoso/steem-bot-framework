class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions do |t|
      t.string :action
      t.integer :bot_id

      t.timestamps
    end
  end
end
