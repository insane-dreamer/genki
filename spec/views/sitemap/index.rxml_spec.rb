require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sitemap/index.rxml" do
  before(:each) do
    mock_tag = mock_model(Tag,
      :name => 'code'
    )

    mock_post = mock_model(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :published_at      => 1.year.ago,
      :edited_at         => 1.year.ago,
      :slug              => 'a-post',
      :approved_comments => [mock_model(Comment)],
      :tags              => [mock_tag]
    )
    
    mock_page = mock_model(Page,
      :title             => 'A Page',
      :body_html         => 'Page content',
      :published_at      => 1.year.ago,
      :updated_at        => 1.year.ago,
      :slug              => 'a-page'
    )

    assigns[:posts] = [mock_post, mock_post]
    assigns[:pages] = [mock_page]
  end

  it "should render list of posts and pages" do
    render "/sitemap/index.rxml"
  end
end
