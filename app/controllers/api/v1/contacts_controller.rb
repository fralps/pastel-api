# frozen_string_literal: true

module Api
  module V1
    # Contacts controller to send contact email
    class ContactsController < ApiController
      skip_before_action :authenticate_user!, only: :create

      def create
        ContactMailer.visitor_contact_email(visitor_contact_params).deliver_now
      end

      private

      def visitor_contact_params
        params.expect(form: [
                        :email,
                        :fullname,
                        :message,
                        :subject
                      ])
      end
    end
  end
end
