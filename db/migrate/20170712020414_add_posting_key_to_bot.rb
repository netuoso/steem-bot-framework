class AddPostingKeyToBot < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :posting_key, :string
  end
end
