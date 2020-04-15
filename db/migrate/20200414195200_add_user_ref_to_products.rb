class AddUserRefToProducts < ActiveRecord::Migration[6.0]
#   def change
#     add_reference :products, :user, null: false, foreign_key: true
#   end

  def self.up
    add_reference :products, :user, foreign_key: true
    change_column :products, :user_id, :integer, null: false, foreign_key: true
  end

  def self.down
    remove_column :products, :user_id
  end
end
