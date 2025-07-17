# frozen_string_literal: true

# Contact form mailer
class ContactMailer < ApplicationMailer
  def visitor_contact_email(visitor_params)
    @fullname = visitor_params[:fullname]
    @email = visitor_params[:email]
    @subject = visitor_params[:subject]
    @message = visitor_params[:message]
    mail(
      to: ENV.fetch('CONTACT_EMAIL', nil),
      subject: I18n.t('mailer.contact.visitor_subject')
    )
  end
end
