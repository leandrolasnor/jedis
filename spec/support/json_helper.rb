# frozen_string_literal: true

module JsonHelper
  def parsed_body
    JSON.parse(response.body, symbolize_names: true) if response.body.presence
  end
end
