class AddFieldsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :s3_url, :text
    add_column :photos, :status_id, :integer
    add_column :photos, :status_create_date, :datetime
  end
end
