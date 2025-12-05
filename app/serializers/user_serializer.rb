# frozen_string_literal: true

# User Serializer
class UserSerializer < Blueprinter::Base
  identifier :id

  fields :confirmed_at,
         :email,
         :firstname,
         :lastname,
         :role

  field :created_at do |user|
    user.created_at.strftime('%d/%m/%Y')
  end
end
