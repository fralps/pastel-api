# frozen_string_literal: true

# Helper method to use in request specs
module RequestHelpers
  def json_response
    @json_response ||= JSON.parse(response.body)
  end

  def auth_headers(user)
    headers = {}
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end
