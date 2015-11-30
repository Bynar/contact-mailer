class Contact < ActiveRecord::Base

  scope :full_name_uniq_emails_not_in_leads,
        -> { joins('left join leads on contacts.email = leads.raw_email')
                 .group("contacts.email")
                 .having("count(leads.id)=0 and count(contacts.email) > 0")
                 .maximum(:full_name) }

  scope :by_created_dates, -> { group("CAST(created_at as DATE)").order("CAST(created_at as DATE)") }

  def self.created
    self.by_created_dates.count
  end

  def first_name
    NameService.first_name(full_name)
  end

  def last_name
    NameService.last_name(full_name)
  end
end
