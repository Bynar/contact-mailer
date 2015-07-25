require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  test "should find first name" do
    contact = Contact.new(full_name: "Joe B. Cool")
    assert contact.first_name == "Joe B."
  end

  test "should find last name" do
    contact = Contact.new(full_name: "Joe B. Cool")
    assert contact.last_name == "Cool"
  end
end
