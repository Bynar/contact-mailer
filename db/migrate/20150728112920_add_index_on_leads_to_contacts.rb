class AddIndexOnLeadsToContacts < ActiveRecord::Migration
  def change
    add_index :contacts, :lead_id
  end
end
