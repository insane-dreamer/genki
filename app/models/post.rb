class Post < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  acts_as_taggable
  # allow html in body and summary
  xss_terminate :except => [:summary, :body]
  auto_sanitize :except => [:summary, :body]
  
  has_many                :comments, :dependent => :destroy
  has_many                :approved_comments, :class_name => 'Comment'
  belongs_to              :section

  before_validation       :generate_slug
  before_validation       :set_dates
  before_save             :apply_filter

  validates_presence_of   :title, :slug, :body, :section_id

  validate                :validate_published_at_natural
  attr_accessor           :direction

  named_scope :published, :order => 'published_at DESC', :conditions => { :published => true }
  named_scope :unpublished, :order => 'published_at DESC', :conditions => { :published => false }

  define_index do
    indexes body, :as => :post, :sortable => true
    indexes author, :sortable => true
    has created_at, updated_at, published_at
  end 
  
  sphinx_scope(:pubbed) { 
    {:with => { :published_at => 2.years.ago.to_i..Time.now.to_i } }
    }
  sphinx_scope(:latest_first) {
    {:order => 'published_at DESC' }
    }

  def validate_published_at_natural
    errors.add("published_at_natural", "Unable to parse time") unless published?
  end

  attr_accessor :minor_edit
  def minor_edit
    @minor_edit ||= "1"
  end

  def minor_edit?
    self.minor_edit == "1"
  end
  
  def published?
    published_at?
  end
  
  def publishable?
    true if self.published_at < Time.now
  end

  attr_accessor :published_at_natural
  def published_at_natural
    @published_at_natural ||= published_at.send_with_default(:strftime, 'now', "%Y-%m-%d %H:%M")
  end

  class << self

    def latest(section,num=1)
      Post.published.all(:conditions => ["section_id = ?", section], :limit => num)
    end

    def build_for_preview(params)
      post = Post.new(params)
      post.generate_slug
      post.set_dates
      post.apply_filter
      TagList.from(params[:tag_list]).each do |tag|
        post.tags << Tag.new(:name => tag)
      end
      post
    end

    def find_recent(options = {})
      tag = options.delete(:tag)
      options = {
        :order      => 'posts.published_at DESC',
        :conditions => ['published_at < ?', Time.now],
        :limit      => DEFAULT_LIMIT
      }.merge(options)
      if tag
        find_tagged_with(tag, options)
      else
        find(:all, options)
      end
    end

    def find_by_permalink(year, month, day, slug, options = {})
      begin
        day = Time.parse([year, month, day].collect(&:to_i).join("-")).midnight
        post = find_all_by_slug(slug, options).detect do |post|
          [:year, :month, :day].all? {|time|
            post.published_at.send(time) == day.send(time)
          }
        end 
      rescue ArgumentError # Invalid time
        post = nil
      end
      post || raise(ActiveRecord::RecordNotFound)
    end

    def find_all_grouped_by_month
      posts = find(
        :all,
        :order      => 'posts.published_at DESC',
        :conditions => ['published_at < ?', Time.now]
      )
      month = Struct.new(:date, :posts)
      posts.group_by(&:month).inject([]) {|a, v| a << month.new(v[0], v[1])}
    end
  end

  def destroy_with_undo
    transaction do
      self.destroy
      return DeletePostUndo.create_undo(self)
    end
  end

  def month
    published_at.beginning_of_month
  end

  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
    self.summary_html = EnkiFormatter.format_as_xhtml(self.summary)
  end

  def set_dates
    self.edited_at = Time.now if self.edited_at.nil? || !minor_edit?
    self.published_at = Chronic.parse(self.published_at_natural)
  end

  def denormalize_comments_count!
    Post.update_all(["approved_comments_count = ?", self.approved_comments.count], ["id = ?", self.id])
  end

  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end

  def next(num=1)
    # finds next published within current section only
    # requires sorting oldest to newest and then reversing the result 
    Post.published.all(:conditions => ["published_at > ? and section_id = ?", self.published_at, self.section_id], :limit => num, :order => 'published_at').reverse
  end
  
  def previous(num=1)
    # finds previous published within current section only
    Post.published.all(:conditions => ["published_at < ? and section_id = ?", self.published_at, self.section_id], :limit => num)
  end

  def excerpt(length=55)
    spaces = self.body.length >= length ? 0 : length - self.body.length
    self.body.blank? ? '&nbsp;' : self.body[0..length] + (' ' * spaces) 
  end
  
  def title?(length=30)
    self.title.blank? ? '[Untitled]' : self.title[0..length]
  end
  
  # TODO: Contribute this back to acts_as_taggable_on_steroids plugin
  def tag_list=(value)
    value = value.join(", ") if value.respond_to?(:join)
    super(value)
  end
end

