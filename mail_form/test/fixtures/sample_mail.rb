class SampleMail < MailForm::Base
  attributes :name, :email, :nickname
  validates :nickname, absence: true

  def headers
    {from: email, to: 'recipients@example.com'}
  end
end