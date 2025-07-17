# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactMailer do
  describe 'visitor_contact_email' do
    let(:visitor_params) do
      {
        fullname: 'John Doe',
        email: 'john@doe.fr',
        subject: 'My subject',
        message: 'My message'
      }
    end

    let(:mail) { described_class.visitor_contact_email(visitor_params) }

    it 'renders correct subject header' do
      expect(mail.subject).to eq(I18n.t('mailer.contact.visitor_subject'))
    end

    it "includes visitor's full name in email body" do
      expect(mail.body.encoded).to include(visitor_params[:fullname])
    end

    it "includes visitor's email in email body" do
      expect(mail.body.encoded).to include(visitor_params[:email])
    end

    it "includes visitor's subject in email body" do
      expect(mail.body.encoded).to include(visitor_params[:subject])
    end

    it "includes visitor's message in email body" do
      expect(mail.body.encoded).to include(visitor_params[:message])
    end

    it 'renders correct email header' do
      expect(mail.to).to eq([ENV.fetch('CONTACT_EMAIL', nil)])
    end
  end
end
