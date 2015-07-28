class AddTwittererRefToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :twitterer_id, :integer, index: true
    add_index :leads, :twitterer_id
    add_foreign_key :leads, :twitterers
  end
end
