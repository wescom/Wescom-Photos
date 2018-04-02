# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts '*******************************************'
puts 'Creating initial DefaultSetting record ...'
puts ' - This record still needs to be edited by an Admin with applicable data for the first site.'

# Create record for Bend location
location_id = Location.find_by_name("Bend").id
if DefaultSetting.find_by_location_id(location_id).nil?
  default_setting = DefaultSetting.create([
    { 
      location_id: location_id,
      image_use_license: "Image Use License...",
      confirmation_from_email: "",
      home_welcome_text: "Welcome text goes here"
    }
  ])
  puts 'DefaultSetting record created... ID #' + default_setting.first.id.to_s
else
  puts 'DefaultSetting record already exists for ID #' + location_id.to_s
end

puts '*******************************************'
puts 'Creating initial DefaultPricing records ...'
default_pricing = DefaultPricing.create([
    { 
      default_setting_id: location_id,
      active: false,
      item_type: "StoryImage",
      price_name: "High Resolution",
      price_quality: "Hires",
      price_tooltip: "Original file provided by the photographer. Suitable for large prints as well as digital use.",
      price_description: "High Resolution Image Download",
      price: "0.00"
    },
    { 
      default_setting_id: location_id,
      active: false,
      item_type: "StoryImage",
      price_name: "Low Resolution",
      price_quality: "Lowres",
      price_tooltip: "Suitable for small prints and digital use.",
      price_description: "Low Resolution Image Download",
      price: "0.00"
    },
    { 
      default_setting_id: location_id,
      active: false,
      item_type: "PDFImage",
      price_name: "High Resolution",
      price_quality: "Hires",
      price_tooltip: "High resolution pdf of printed page. Suitable for large prints as well as digital use.",
      price_description: "High Resolution PDF Download",
      price: "0.00"
    }
  ])
puts 'DefaultPricing records created: '+default_pricing.count.to_s

