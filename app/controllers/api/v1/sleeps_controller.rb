# frozen_string_literal: true

module Api
  module V1
    # Sleeps controller
    class SleepsController < ApiController
      include SearchConcern

      before_action :find_sleep, only: [:show, :update, :destroy]
      before_action :format_date_params, only: [:create, :update]

      def index
        sleeps = current_user.sleeps.ordered_by_date

        search_query ? sleeps = search_by_title(sleeps, search_query) : sleeps

        @pagy, user_sleeps = pagy(:offset, sleeps, limit: Sleep::ITEMS_PER_PAGE)

        render json: {
          total_pages: @pagy.count,
          total_sleeps: sleeps.size,
          paginated_result: SleepSerializer.render_as_hash(user_sleeps.includes(:tags), view: :index_and_create),
          status: :ok
        }
      end

      def show
        render json: SleepSerializer.render(@sleep, view: :update_and_show), status: :ok
      end

      def create
        sleep = current_user.sleeps.build(sleep_params)

        if sleep.save
          render json: SleepSerializer.render(sleep, view: :index_and_create), status: :created
        else
          render json: sleep.errors, status: :unprocessable_content
        end
      end

      def update
        if @sleep.update(sleep_params)
          render json: SleepSerializer.render(@sleep, view: :update_and_show)
        else
          render json: @sleep.errors, status: :unprocessable_content
        end
      end

      def destroy
        return render status: :no_content if @sleep.destroy

        render json: { errors: [{
          code: 'sleep_not_deletable',
          message: 'Sleep could not be deleted'
        }] },
               status: :unprocessable_content
      end

      private

      def find_sleep
        @sleep = current_user.sleeps.find(params[:id])
      end

      def format_date_params
        date_hash = params[:sleep][:date]

        timestamp = Time.zone.local(date_hash['year'], date_hash['month'], date_hash['day'])

        params[:sleep][:date] = timestamp
      end

      def sleep_params
        params.expect(sleep: [
                        :date,
                        :description,
                        :id,
                        :intensity,
                        :current_mood,
                        :title,
                        :updated_at,
                        :sleep_type,
                        :happened,
                        { tags_attributes: [tags_attributes] }
                      ])
      end

      def tags_attributes
        [
          :_destroy,
          :id,
          :name,
          :taggable_type,
          :taggable_id
        ]
      end
    end
  end
end
