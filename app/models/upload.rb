class Upload < ActiveRecord::Base
  has_attached_file :file, :styles => { :original => "x640>", :thumb => "100>" }, :whiny => false
#  validates_attachment_content_type :file, :content_type => ['image/jpeg','image/png','image/gif','text/rtf','text/html',"application/pdf", "application/zip", "application/msword", "application/vnd.ms-excel","application/octet-stream"]
  validates_attachment_size :file, :in => (1..200.megabytes)
  before_file_post_process :check_for_image

  named_scope :images, :conditions => [ 'file_content_type LIKE ?', '%image%' ], :order => 'created_at DESC'
  named_scope :recent, :limit => 25, :order => 'created_at DESC'

  def is_image?
    self.file.content_type.include?('image')
  end

  def check_for_image
    return false unless self.is_image?
  end

end
