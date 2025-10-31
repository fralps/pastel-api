# frozen_string_literal: true

# Sleep Serializer
class SleepSerializer < Blueprinter::Base
  identifier :id

  view :index_and_create do
    fields :current_mood, :date, :description, :sleep_type, :title

    association :tags, name: :tags_attributes, blueprint: TagSerializer
  end

  view :update_and_show do
    fields :current_mood,
           :date,
           :description,
           :happened,
           :intensity,
           :sleep_type,
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
