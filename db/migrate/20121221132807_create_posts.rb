class CreatePosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.datetime :created_at
      t.datetime :published_at
    end
    add_index :posts, :title
  end

  def down
    drop_table :posts
  end
end
