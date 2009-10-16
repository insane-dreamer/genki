class Section < ActiveRecord::Base

has_many :posts

validates_presence_of :name, :message => "can't be blank"

end
