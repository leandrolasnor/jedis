# frozen_string_literal: true

class SearchPeople::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:page), default: -> { SearchPeople::Models::Person }, reader: :private
  option :searcher, type: Instance(Proc), default: -> { proc { model.ms_raw_search(_1 || '', limit: _2, offset: _3) } }, reader: :private

  def call(query: '', page: 1, per_page: 5)
    Try { searcher.(query, per_page.to_i, (page.to_i - 1) * per_page.to_i)['hits'] }
  end
end
