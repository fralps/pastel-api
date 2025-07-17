# frozen_string_literal: true

# Captures the app backend errors
module JsonErrors
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    rescue_from StandardError,                      with: :render500
    rescue_from ActiveRecord::RecordNotFound,       with: :render404 # Mongoid::Errors::DocumentNotFound
    rescue_from ActionController::ParameterMissing, with: :render400

    def render400(errors = 'required parameters invalid')
      render_errors(errors, 400)
    end

    def render401(errors = 'unauthorized access')
      render_errors(errors, 401)
    end

    def render404(errors = 'not found')
      render_errors(errors, 404)
    end

    def render422(errors = 'could not save data')
      render_errors(errors, 422)
    end

    def render500(errors = 'internal server error')
      render_errors(errors, 500)
    end

    def render_errors(errors, status = 400)
      if errors.try(:backtrace)
        Rails.logger.fatal(errors.backtrace.join("\n"))
      else
        Rails.logger.fatal(errors)
      end

      data = {
        status: 'failed',
        errors: Array.wrap(errors)
      }

      render json: data, status:
    end
  end
end
