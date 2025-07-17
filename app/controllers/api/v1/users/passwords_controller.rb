# frozen_string_literal: true

module Api
  module V1
    module Users
      # PasswordsController
      class PasswordsController < Devise::PasswordsController
        include ApiConcern
      end
    end
  end
end
