class AddUserToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :twitter_user, :string
  end
end
