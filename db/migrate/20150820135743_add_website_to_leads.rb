class AddWebsiteToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :website, :string
    add_index :leads, :website
  end
end
