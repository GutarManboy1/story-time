class AddAdminToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
#needed for certain heroku features to work.
