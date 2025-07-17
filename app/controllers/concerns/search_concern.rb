# frozen_string_literal: true

# Search querying concern
module SearchConcern
  extend ActiveSupport::Concern

  included do
    # Returns query from params
    def search_query
      return if params[:query].blank?

      params[:query].downcase
    end

    # Return search results with a title query
    def search_by_title(records, query)
      record_ids = records.select { |r| r.title.downcase.include?(query) }
                          .map(&:id)

      records.where(id: record_ids)
    end
  end
end
