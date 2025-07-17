# frozen_string_literal: true

module Api
  module V1
    module Users
      # SessionsController
      class SessionsController < Devise::SessionsController
        include ApiConcern
      end
    end
  end
end
