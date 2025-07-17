# frozen_string_literal: true

# Sleep Serializer
class SleepSerializer < Blueprinter::Base
  identifier :id

  view :index_and_create do
    fields :title

    field :date do |sleep|
      sleep.date.strftime('%d/%m/%Y')
    end
  end

  view :update_and_show do
    fields :date,
           :description,
           :happened,
           :intensity,
           :current_mood,
           :title

    field :datepicker_date do |sleep|
      sleep.date.strftime('%m/%d/%Y')
    end

    field :formatted_date do |sleep|
      sleep.date.strftime('%d/%m/%Y')
    end

    association :tags, name: :tags_attributes, blueprint: TagSerializer
  end
end
