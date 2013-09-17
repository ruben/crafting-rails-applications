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
end
