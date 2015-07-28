class AddTwittererRefToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :twitterer_id, :integer, index: true
    add_index :contacts, :twitterer_id
    add_foreign_key :contacts, :twitterers  end
end
