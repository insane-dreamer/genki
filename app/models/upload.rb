class Upload < ActiveRecord::Base
  has_attached_file :file

  named_scope :images, :conditions => [ 'file_content_type LIKE ?', '%image%' ], :order => 'created_at DESC'

  def is_image?
    self.file.content_type.include?('image')
  end

end
