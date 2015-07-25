class AddLeadReferenceToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :lead_id, :integer
    add_foreign_key :contacts, :leads
  end
end
