class Section < ActiveRecord::Base

has_many :posts

attr_accessor_with_default :new_content, 0

validates_presence_of :name, :message => "can't be blank"
validates_presence_of :per_page, :message => "can't be blank"
validates_numericality_of :per_page, :only_integer => true, :message => "can only be whole number."
validates_inclusion_of :per_page, :in => 1..2, :message => "can only be between 1 and 2."
validates_numericality_of :position, :only_integer => true, :message => "can only be whole number."

named_scope :show_on_front, :conditions => ['frontpage = ?', true], :order => "position ASC" 


  def description_excerpt
    excerpt = self.description ? self.description[0..50] : ''
    excerpt + '...' if excerpt.length > 51
  end
  
  def name_path
    self.name.parameterize
  end

  def new_content_since(last_visit)
    self.new_content = self.posts.count(:conditions => ["published_at > ? and published = ?", last_visit.to_time.utc, true]) if last_visit
    self.new_content
  end

end
