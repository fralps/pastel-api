# frozen_string_literal: true

# ActionMailer entrypoint
class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper
  default from: ENV.fetch('CONTACT_EMAIL', nil)
  layout 'mailer'
end
