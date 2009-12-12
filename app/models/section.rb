class Section < ActiveRecord::Base

has_many :posts

validates_presence_of :name, :message => "can't be blank"
validates_presence_of :per_page, :message => "can't be blank"

named_scope :show_on_front, :conditions => ['frontpage = ?', true]

end
