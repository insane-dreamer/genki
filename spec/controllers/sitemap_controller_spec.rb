require File.dirname(__FILE__) + '/../spec_helper'

describe 'successful sitemap', :shared => true do
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end

  it "should assign the found posts and pages for the view" do
    do_get
    assigns[:posts].should == @posts
    assigns[:pages].should == @pages
  end
end
