# frozen_string_literal: true

# Application helper
module ApplicationHelper
  def front_url(path = '')
    "#{ENV.fetch('WEB_BASE_URL')}/#/#{path}"
  end
end
