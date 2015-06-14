class Response < ActiveRecord::Base

  TYPES = %w(XML JSON 500 404 422_JSON 422_XML)
  REQUEST_TYPES = %w(GET POST)

  validates_presence_of :request_type, :response_type, :content, :request_by
  validates_uniqueness_of :request_by, scope: :request_type

  validates_length_of :request_type, :response_type, :request_by, maximum: 50
  validates_inclusion_of :response_type, in: TYPES
  validates_inclusion_of :request_type, in: REQUEST_TYPES
end
