# frozen_string_literal: true

module Api
  module V1
    # Pings controller
    # use to waking up Heroku dyno
    class PingsController < ApiController
      skip_before_action :authenticate_user!, only: :index

      def index
        render json: { dyno_status: 'Dyno is up and running' }, status: :ok
      end
    end
  end
end
