# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Admin users ressource manager
      class UsersController < ApiController
        before_action :authenticate_admin!, :double_admin_check, only: [:index, :destroy]
        before_action :find_user, only: :destroy

        def index
          users = User.order(id: :desc).where.not(id: @current_admin.id)

          @pagy, users = pagy(:offset, users, limit: User::ITEMS_PER_PAGE)

          render json: {
            total_pages: @pagy.count,
            paginated_result: UserSerializer.render(users),
            count: User.all.size,
            status: :ok
          }
        end

        def destroy
          return render status: :no_content if @user.destroy

          render json: { errors: [{
            code: 'user_not_deletable',
            message: 'User could not be deleted'
          }] },
                 status: :unprocessable_content
        end

        private

        # Why not?
        def double_admin_check
          render401 unless @current_admin.admin?
        end

        def find_user
          @user = User.includes(user_includes).find(params[:id])
        end

        def user_includes
          {
            sleeps: [:tags]
          }
        end
      end
    end
  end
end
