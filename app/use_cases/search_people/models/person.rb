# frozen_string_literal: true

class SearchPeople::Models::Person < ApplicationRecord
  include MeiliSearch::Rails

  meilisearch index_uid: 'person'
end
