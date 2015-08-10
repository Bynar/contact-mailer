class ContactWriter

  def self.write(results)
    Contact.create(
        results.map do |r|
          { full_name: r[0], website: r[1] , email: r[2], context: r[3], form: r[4] }
        end
    )
  end
end
