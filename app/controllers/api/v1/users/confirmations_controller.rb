# frozen_string_literal: true

module Api
  module V1
    module Users
      # ConfirmationsController
      class ConfirmationsController < Devise::ConfirmationsController
        include ApiConcern
      end
    end
  end
end
