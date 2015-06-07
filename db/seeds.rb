# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Card.find_or_create_by(title: 'Timeout') do |card|
  card.caption = 'Tests timeouts'
  card.description = "The url allows you to do a GET request. You can specify the timeout value which is in seconds with the param time like shown below"
  card.link = "/timeout?time=10"
end
