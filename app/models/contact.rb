class Contact < ActiveRecord::Base

  def first_name
    return '' if full_name.nil?

    if full_name.split.count > 1
      full_name.split[0..-2].join(' ')
    else
      full_name
    end
  end

  def last_name
    return '' if full_name.nil?

    if full_name.split.count > 1
      full_name.split.last
    end
  end
end
