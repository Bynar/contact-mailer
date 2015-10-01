class ContactSaver

  def self.save_with_filter(date, file, filter, limit)
    patterns = CSV.read(filter)

    patterns.each do |p_row|
      CSV.open(file, 'ab') do |csv|
        Contact.joins('inner join twitterers on contacts.website = twitterers.real_url')
            .select('contacts.full_name, contacts.website, contacts.email, contacts.context, contacts.form, twitterers.followers_count')
            .where('contacts.created_at >= ?', DateTime.parse(date))
            .where('twitterers.followers_count < ?', 3000)
            .where('contacts.full_name is not null')
            .limit(limit)
            .each do |r| # write results

          pattern = p_row[0]

          if r.email && r.email.match(/#{pattern}/i)
            cleaned_email = EmailCleaner.clean(r.email)
            csv << [r.full_name, r.website, r.email, cleaned_email, r.context, r.form, r.followers_count]
          end
        end
      end
    end
  end
end
