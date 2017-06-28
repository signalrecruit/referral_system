class Attachment < ActiveRecord::Base
  belongs_to :job_description

  mount_uploader :file, AttachmentUploader
end
