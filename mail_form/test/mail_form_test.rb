require 'test_helper'
require 'fixtures/sample_mail'

class MailFormTest < ActiveSupport::TestCase

  test "sample mail has name and email attributes" do
    @sample_mail = SampleMail.new

    @sample_mail.name = "User"
    assert_equal "User", @sample_mail.name
    @sample_mail.email = "user@example.com"
    assert_equal "user@example.com", @sample_mail.email
  end

  test "sample mail can clear attributes using the clear_ prefix" do
    sample_mail = SampleMail.new

    sample_mail.name = 'User'
    assert_equal 'User', sample_mail.name
    sample_mail.email = 'user@example.com'
    assert_equal 'user@example.com', sample_mail.email

    sample_mail.clear_name
    assert_equal nil, sample_mail.name
    sample_mail.clear_email
    assert_equal nil, sample_mail.email
  end

  test "sample mail can ask for the presence of an attribute value using the ? suffix" do
    sample_mail = SampleMail.new

    assert !sample_mail.name?

    sample_mail.name = 'User'
    assert sample_mail.name?

    sample_mail.email = ""
    assert !sample_mail.email?
  end
end
