# frozen_string_literal: true

# Main controller
class ApplicationController < ActionController::API
  include Pagy::Method

  respond_to :json
end
