class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :chat_id
      t.boolean :user

      t.timestamps
    end
  end
end
