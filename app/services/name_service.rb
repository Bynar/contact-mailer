class NameService

  def self.first_name(full_name)
    return '' if full_name.nil?

    if full_name.split.count > 1
      full_name.split[0..-2].join(' ')
    else
      full_name
    end
  end

  def self.last_name(full_name)
    return '' if full_name.nil?

    if full_name.split.count > 1
      full_name.split.last
    else
      ''
    end
  end
end
