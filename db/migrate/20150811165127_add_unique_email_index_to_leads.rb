class AddUniqueEmailIndexToLeads < ActiveRecord::Migration
  def change
    remove_index :leads, :email
    add_index :leads, :email, unique: true
  end
end
