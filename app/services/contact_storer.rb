class ContactStorer
  FIRST_ROW = ['Name', 'Website Url', 'e-mail', 'e-mail url', 'contact page URL']

  def self.store(default_date, files)

    files.each do |file|

      contacts = CSV.read(file, "r:ISO-8859-1")

      contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]

      contacts.reject! { |c| c[1].nil? }

      created_at = default_date || File.mtime(file)

      Contact.create(
          contacts.map do |contact|
            {
                full_name: contact[0],
                website: contact[1],
                email: contact[2],
                context: contact[3],
                form: contact[4],
                created_at: created_at
            }
          end
      )
    end
  end
end
