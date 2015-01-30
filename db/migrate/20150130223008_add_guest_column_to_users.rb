class AddGuestColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guest, :boolean, default: false, null: false
  end
end
