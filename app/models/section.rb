class Section < ActiveRecord::Base

has_many :posts

validates_presence_of :name, :message => "can't be blank"
validates_presence_of :per_page, :message => "can't be blank"
validates_numericality_of :per_page, :only_integer => true, :message => "can only be whole number."
validates_inclusion_of :per_page, :in => 1..2, :message => "can only be between 1 and 2."

named_scope :show_on_front, :conditions => ['frontpage = ?', true]


  def description_excerpt
    excerpt = self.description ? self.description[0..50] : ''
    excerpt + '...' if excerpt.length > 51
  end
  
  def name_path
    self.name.parameterize
  end

end
