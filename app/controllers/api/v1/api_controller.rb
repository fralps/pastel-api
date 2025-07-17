# frozen_string_literal: true

module Api
  module V1
    # Main API controller
    class ApiController < ::ApplicationController
      include ApiConcern

      before_action :authenticate_user!

      def check_page_params
        params[:page] = '1' unless params[:page].present? && params[:page].to_i.integer? && params[:page].to_i.positive?
      end

      private

      # Add security to be sure that the user accessing admin controllers
      # is an admin user
      def authenticate_admin!
        return if current_user.blank?

        return render401 unless current_user.admin?

        @current_admin = current_user
      end
    end
  end
end
