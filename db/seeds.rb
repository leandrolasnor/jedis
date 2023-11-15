# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

30.times do
  p = FactoryBot.create(:person)
  a = FactoryBot.build(:address)
  c = FactoryBot.build(:contact)

  a.person_id = p.id
  c.person_id = p.id

  a.save
  c.save
end
