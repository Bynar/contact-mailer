class RemoveReferencesBetweenEntities < ActiveRecord::Migration
  def change
    remove_column :contacts, :lead_id
    remove_column :contacts, :twitterer_id
    remove_column :leads, :twitterer_id
  end
end
