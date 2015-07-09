class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :image_url
      t.decimal :rating
      t.string :video_url
      t.decimal :duration
      t.boolean :hand_picked

      t.timestamps null: false
    end
  end
end
