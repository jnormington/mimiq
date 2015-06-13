class Response < ActiveRecord::Base

  TYPES = %w(XML JSON 500 404)
  REQUEST_TYPES = %w(GET POST)

  validates_presence_of :request_type, :response_type, :content
  validates_uniqueness_of :request_by, scope: :request_type

  validates_length_of :request_type, :response_type, :request_by, maximum: 50
  validates_inclusion_of :response_type, in: TYPES
  validates_inclusion_of :request_type, in: REQUEST_TYPES
end
