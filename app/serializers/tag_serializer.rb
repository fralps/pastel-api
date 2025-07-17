# frozen_string_literal: true

# Tag Serializer
class TagSerializer < Blueprinter::Base
  identifier :id

  fields :name
end
