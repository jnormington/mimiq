# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Card.find_or_create_by(title: 'Timeout') do |card|
  card.caption = 'Tests server response after preset time'
  card.description = "The url allows you to do a GET request.
    It will respond after 5 seconds by default or specified time, try below"
  card.link = "/scenario/timeout?time=10"
end

Card.find_or_create_by(title: 'Not Found (404)') do |card|
  card.caption = 'Tests server responding with 404'
  card.description = "The url allows you to do a GET request.
    It always responds with a 404 http status with the public/404.html page"
  card.link = "/scenario/not_found"
end

Card.find_or_create_by(title: 'Server Error (500)') do |card|
  card.caption = 'Tests server responding with 500'
  card.description = "The url allows you to do a GET request.
    It always responds with a 500 http status with the public/500.html page"
  card.link = "/scenario/server_error"
end

Card.find_or_create_by(title: 'Manage custom responses') do |card|
  card.caption = 'Create custom responses for get and post'
  card.description = "The url allows you to do a POST request and it respond with your
    content you have configured. It can be JSON/XML or just plain old html"
  card.link = "/responses"
end

Response.create!(
  response_type: 'JSON',
  content: "{blank: 'yes'}",
  request_type: 'GET',
  request_by: 'test'
)

Response.create!(
  response_type: '500',
  content: 'never used but something required as /public/500.html used',
  request_type: 'POST',
  request_by: 'test'
)
