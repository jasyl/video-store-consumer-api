class VideoSerializer < ActiveModel::Serializer
  attribute :id, if: -> { object.id != nil }

  attributes :title, :overview, :release_date, :image_url, :external_id
end
