class AddRawEmailToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :raw_email, :string
    add_index :leads, :raw_email, unique: true
  end
end
