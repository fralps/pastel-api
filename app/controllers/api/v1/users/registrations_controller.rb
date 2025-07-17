# frozen_string_literal: true

module Api
  module V1
    module Users
      # RegistrationsController
      class RegistrationsController < Devise::RegistrationsController
        include ApiConcern

        before_action :configure_permitted_parameters, if: :devise_controller?

        def update
          super do |resource|
            return render json: UserSerializer.render(resource), status: :ok if resource.errors.empty?

            return render422(resource.errors)
          end
        end

        protected

        # We define permission to first_name, last_name, ...
        # for the sign_up form in order to add users into our database
        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_attributes)
          devise_parameter_sanitizer.permit(:account_update, keys: account_update_attributes)
        end

        private

        def sign_up_attributes
          [
            :email,
            :firstname,
            :lastname
          ]
        end

        def account_update_attributes
          [
            :firstname,
            :lastname,
            :password,
            :password_confirmation
          ]
        end
      end
    end
  end
end
