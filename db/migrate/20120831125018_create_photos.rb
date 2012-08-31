class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.text :url
      t.text :caption

      t.timestamps
    end
  end
end
