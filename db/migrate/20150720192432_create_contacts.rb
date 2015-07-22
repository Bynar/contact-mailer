class CreateContacts < ActiveRecord::Migration
  def up
    create_table :contacts do |t|
      t.string :full_name, index: true
      t.string :email, index: true
      t.string :website, null: false, index: true
      t.string :form
      t.string :context

      t.timestamps
    end

    execute "CREATE INDEX index_contacts_on_email_full_name ON contacts (email, full_name)"

  end

  def down
    drop_table :contacts
  end
end
