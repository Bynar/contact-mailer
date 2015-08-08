class Contact < ActiveRecord::Base

  scope :full_name_uniq_emails_not_in_leads,
        -> { joins('left join leads on contacts.email = leads.email')
                 .group("contacts.email")
                 .having("count(leads.id)=0 and count(contacts.email) > 0")
                 .maximum(:full_name) }

  def first_name
    NameService.first_name(full_name)
  end

  def last_name
    NameService.last_name(full_name)
  end
end
