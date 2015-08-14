class Lead < ActiveRecord::Base
  scope :unsent, -> { where(mandrill_sent_date: nil) }
  scope :with_template, -> (template) { where(mandrill_template: template) }
end
