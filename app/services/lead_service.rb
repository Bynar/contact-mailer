require 'csv'

class LeadService
  FIRST_ROW = ['Full Name', 'Website', 'Email', 'Cleaned Email', 'Sent Date', 'Template']

  def self.contacts(input_file, limit)
    contacts = CSV.read(input_file, "r:ISO-8859-1")
    contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]
    contacts = contacts.first(limit.to_i) unless limit.nil?
    contacts
  end

  def self.process(first_name, last_name, raw_email, email, website, mandrill_sent_date, mandrill_template, default_sent_date, default_template, created_at)
    if Lead.where('lower(email) = ?', email.downcase).blank? &&
        Lead.where('lower(raw_email) = ?', raw_email.downcase).blank? &&
        ( Lead.where(website: website).blank? || !mandrill_sent_date.nil? ) #past records ok

      Lead.create(
          {
              first_name: first_name,
              last_name: last_name,
              raw_email: raw_email,
              email:  email,
              website: website,
              created_at: created_at,
              mandrill_sent_date: mandrill_sent_date || default_sent_date,
              mandrill_template: mandrill_template || default_template
          }
      )
    end
  end

  def self.passes_name_filter(name, first_name, last_name, filters)
    return false if name.match(/[^a-z\s]/i) # has anything not alphabetical
    return false if name.match(/^[A-Z\s]+$/) # has all CAPS
    return false if first_name.blank? || first_name.match(/^[A-Z\s]+$/) # has all CAPS
    return false if last_name.blank? || last_name.match(/^[A-Z\s]+$/) # has all CAPS
    return false if name.match(/(one|two|three|four|five|six|seven|eight|nine)/i) # has one, two, three...

    filters.each do |pattern|
      if name.split(' ').inject(false) {|r, n| r || n.match(/^#{pattern}$/i)}
        (p "#{name} failed pattern: " + pattern.to_s and return false)
      end
    end

    name
  end

  def self.passes_email_filter(email)
    return false unless email.match(/^.+@/) # meets *@example.com

    filters = %w(admin address admin email e-mail example abuse support customer help)

    filters.each {|pattern| return false if email.match(/^#{pattern}/i) }

    email
  end

  def self.store(input_file, reject_file, filter_file, default_sent_date, default_template, limit, created_at = DateTime.now)
    filters = CSV.read(filter_file, "r:ISO-8859-1").map { |row| row[0]}

    contacts(input_file, limit).each do |contact|

      full_name = contact[0]

      first_name = NameService.first_name(full_name)
      last_name = NameService.last_name(full_name)

      raw_email = contact[2]
      email = EmailCleaner.clean(raw_email).downcase
      website = contact[1]
      mandrill_sent_date = contact[17].nil? ? nil : DateTime.parse(mandrill_sent_date)
      mandrill_template = contact[18]

      rejected(email, full_name, reject_file) and next unless passes_filters(email ,full_name, first_name, last_name, filters)

      unless process(first_name, last_name, raw_email, email, website, mandrill_sent_date, mandrill_template, default_sent_date, default_template, created_at)
        duplicated(raw_email, reject_file)
      end

    end
  end

  def self.passes_filters(email ,full_name, first_name, last_name, filters)
    passes_email_filter(email) && passes_name_filter(full_name, first_name, last_name, filters)
  end

  def self.rejected(email, full_name, reject_file)
    # p 'Contact did not pass filter: ' + email + ' : ' + full_name
    CSV.open(reject_file, 'ab') do |csv|
      csv << [email, full_name]
    end
  end

  def self.duplicated(raw_email, reject_file)
    p 'Leads already contains a record with that email: ' + raw_email

    CSV.open(reject_file, 'ab') do |csv|
      csv << [raw_email]
    end
  end
end