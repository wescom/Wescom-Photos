# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Creating ADMIN ORDERS RECORD...'
admin_orders = DefaultSetting.create([
  { image_price: 9.99, pdf_price: 9.99, confirmation_from_email: "" }
  ])

puts '  AdminOrder record created.'
