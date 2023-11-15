class CreatePeopleTable < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :taxpayer_number, null: false
      t.string :cns, null: false
      t.string :email, null: false
      t.date :birthdate, null: false
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
