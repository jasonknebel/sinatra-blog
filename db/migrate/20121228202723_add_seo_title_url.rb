class AddSeoTitleUrl < ActiveRecord::Migration
  def change
    add_column :posts, :url, :string

    Post.all.each do |post|
      seo_title = post.title.downcase.gsub(/[^a-z0-9]+/i, '-')
      post.update_attributes(:url => seo_title)
    end
  end
end