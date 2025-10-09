# frozen_string_literal: true

module Api
  module V1
    module Users
      # PasswordsController
      class PasswordsController < Devise::PasswordsController
        include ApiConcern

        def create
          super do |_resource|
            return render json: { status: :ok }, status: :created
          end
        end
      end
    end
  end
end
