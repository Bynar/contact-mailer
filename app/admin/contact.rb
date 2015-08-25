ActiveAdmin.register Contact do

  scope :not_in_leads do |scope|
    scope.where('contacts.id in (select max(contacts.id) from contacts
                left join leads on contacts.email = leads.raw_email
                group by contacts.email
                having count(leads.id)=0 and count(contacts.email) > 0 ) ')

  end
end
