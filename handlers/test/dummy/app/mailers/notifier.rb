class Notifier < ActionMailer::Base

  def contact(recipient)
    @recipient = recipient
    mail(to: recipient, from: 'contact@example.com') do |format|
      format.html
      format.text
    end

  end
end