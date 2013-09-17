class ContactForm < MailForm::Base
  attributes :name, :email, :message

  def headers
    {from: email, to: 'recipient@example.com'}
  end
end