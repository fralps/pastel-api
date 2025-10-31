# frozen_string_literal: true

module Api
  module V1
    module Stats
      # Dashboard stats controller
      class DashboardStatsController < ApiController
        def index
          render json: json_response, status: :ok
        end

        private

        # Final json response for statistics
        def json_response
          {
            totals: {
              dream: current_user.dreams.size,
              lucid: current_user.lucids.size,
              nightmare: current_user.nightmares.size,
              sleep_paralysis: current_user.paralyses.size,
              sleep_walking: current_user.walkings.size,
              sleep_talking: current_user.talkings.size,
              sleep_apnea: current_user.apneas.size,
              erotic: current_user.erotics.size
            }
            # by_month: {
            #   dreams: build_months_records(current_user.dreams),
            #   lucids: build_months_records(current_user.lucids),
            #   nightmares: build_months_records(current_user.nightmares)
            # },
            # by_year: {
            #   dreams: build_years(current_user.dreams),
            #   lucids: build_years(current_user.lucids),
            #   nightmares: build_years(current_user.nightmares)
            # }
          }
        end

        # Returns number of records for each year
        # rubocop:disable Metrics/AbcSize
        # rubocop:disable Metrics/PerceivedComplexity
        def build_years(records)
          dreams_start_date = if current_user.dreams.empty?
                                Time.zone.now
                              else
                                Date.new(current_user.dreams.order(:date).first&.date&.strftime('%Y').to_i).beginning_of_year
                              end

          lucids_start_date = if current_user.lucids.empty?
                                Time.zone.now
                              else
                                Date.new(current_user.lucids.order(:date).first&.date&.strftime('%Y').to_i).beginning_of_year
                              end

          nightmares_start_date = if current_user.nightmares.empty?
                                    Time.zone.now
                                  else
                                    Date.new(
                                      current_user.nightmares.order(:date).first&.date&.strftime('%Y').to_i
                                    ).beginning_of_year
                                  end

          start_date = [
            dreams_start_date,
            lucids_start_date,
            nightmares_start_date
          ].min

          start_date = start_date.beginning_of_year
          end_date = Date.new(Time.zone.now.year).end_of_year

          records.years(start_date..end_date)
        end
        # rubocop:enable Metrics/AbcSize
        # rubocop:enable Metrics/PerceivedComplexity

        # Returns number of records for each current year months
        def build_months_records(records)
          result = records.group_by_month_from_current_year
          months = []

          # 12 for the months of the year
          12.times { |index| months.push("#{Time.zone.now.strftime('%Y')}-#{build_index(index + 1)}") }

          # Add 0 for month without records
          months.each { |month| result[month] ||= 0 }

          result
        end

        # Returns correct month index
        def build_index(index)
          index.to_s.length == 1 ? "0#{index}" : index
        end
      end
    end
  end
end
