ActiveAdmin.register Lead do
  scope :unsent

  scope :template_1 do |scope|
    scope.with_template('template1')
  end

  scope :template_2 do |scope|
    scope.with_template('template2')
  end

  scope :twitter_accounts do |scope|
    scope.where('leads.id in (select max(leads.id) from leads
                left join twitterers on leads.website = twitterers.real_url
                group by leads.website) ')
  end
end
