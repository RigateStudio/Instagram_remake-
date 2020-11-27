# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

User.destroy_all
Post.destroy_all

user = User.create(email:"default@email.com", password: "123123")

images = Dir.entries("app/assets/images").select { |f| File.file? File.join("app/assets/images", f) }
puts images

images.each do |image| 
    Post.create(description: Faker::Hipster.sentence(word_count: 14), user_id: user.id)
    Post.last.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', image)), filename: image, content_type: 'image/png')
end