class Contact < ActiveRecord::Base
  belongs_to :lead

  def first_name
    if full_name.split.count > 1
      full_name.split[0..-2].join(' ')
    else
      full_name
    end
  end

  def last_name
    if full_name.split.count > 1
      full_name.split.last
    end
  end
end
