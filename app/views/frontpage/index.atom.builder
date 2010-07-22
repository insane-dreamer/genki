@rssposts = Post.published.find_recent(:tag => @tag, :include => :tags)

atom_feed(
  :url         => rss_path(:format => 'atom', :only_path => false), 
  :root_url    => root_path
) do |feed|
  feed.title     posts_title(@tag)
  feed.updated   @posts.empty? ? Time.now.utc : @posts.collect(&:edited_at).max
  feed.generator "Win the World", "uri" => "http://wtw.familymembers.com"

  feed.author do |xml|
    xml.name  author.name
    xml.email author.email unless author.email.nil?
  end

  @rssposts.each do |post|
   feed.entry(post, :url => post_path(post, :only_path => false), :published => post.published_at, :updated => post.edited_at) do |entry|
      content = Maruku.new(post.summary).to_html + " " + link_to("Read more...", post)
      entry.title   post.title
      entry.content content, :type => 'html'
    end
  end
end
