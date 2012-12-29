#-----New_Post-----#

post '/admin/new' do
  slim :new 
end

put '/admin/new' do 
  if (params[:title].empty? || params[:content].empty?)
    "You didn't enter something."
  else
    Post.create( title: params[:title], content: params[:content],
      url: seo_title(params[:title].to_s))
    redirect '/admin'
  end
end

#-----Edit_Post-----#

post '/admin/edit/:id' do
  @post = Post.find(params[:id])
  slim :edit
end

put '/admin/edit/:id' do
  Post.find(params[:id]).update_attributes(title: params[:edit_title], 
    content: params[:edit_content], url: seo_title(params[:edit_title].to_s))
  redirect '/admin'
end

#-----Publish_Post-----#

put '/admin/publish/:id' do
  Post.find(params[:id]).update_attributes(published_at: Time.now)
  redirect '/admin'
end

#-----Delete_Post-----#

delete '/admin/:id' do
  Post.find(params[:id]).destroy
  redirect '/admin'
end