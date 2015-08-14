class Lead < ActiveRecord::Base
  scope :unsent, -> { where(mandrill_sent_date: nil) }
end
