# frozen_string_literal: true

# User model
class User < ApplicationRecord
  ITEMS_PER_PAGE = 15

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # By-pass email confirmation for staging env during 1 month
  self.allow_unconfirmed_access_for = 1.month if ENV.fetch('STAGING_ENV') == 'true'

  has_many :sleeps, dependent: :destroy

  enum :role, { user: 'user', admin: 'admin' }

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :role, inclusion: { in: roles.keys }

  def to_json(_arg)
    # Tell Devise to use our custom user serializer
    UserSerializer.render(self)
  end
end
