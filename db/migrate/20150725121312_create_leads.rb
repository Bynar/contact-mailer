class CreateLeads < ActiveRecord::Migration
  def up
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, index: true
      t.string :mandrill_template
      t.timestamp :mandrill_sent_date

      t.timestamps null: false
    end

    execute "CREATE INDEX index_leads_on_first_name_last_name ON leads (first_name, last_name)"

  end

  def down
    drop_table :leads
  end
end
