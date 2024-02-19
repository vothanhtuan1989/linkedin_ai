class CreateConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :connections do |t|
      t.string :first_name
      t.string :last_name
      t.string :url
      t.string :email_address
      t.string :company
      t.string :position
      t.date :connected_on

      t.timestamps
    end
  end
end
