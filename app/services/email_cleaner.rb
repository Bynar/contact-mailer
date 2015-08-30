class EmailCleaner

  def self.clean(email)
    #allow only letters to begin an email?
    result = email.gsub(/^.*%\d(\d|[A-Z])/, '')
    result = result.gsub(/^[^a-z]+/i, '')
    result = result.gsub(/^.*(\.\.|--|__|\+\+)/, '') #doubles in middle
    result
  end
end