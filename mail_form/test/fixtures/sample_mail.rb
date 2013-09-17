class SampleMail < MailForm::Base
  attributes :name, :email

  def headers
    {from: email, to: 'recipients@example.com'}
  end
end