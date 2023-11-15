class CreateContactsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :number, null: false
      t.integer :person_id, null: false

      t.timestamps
    end

    add_foreign_key :contacts, :people, column: :person_id
  end
end
