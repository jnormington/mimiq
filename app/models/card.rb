class Card < ActiveRecord::Base
  validates_presence_of :title, :caption, :description, :link
  validates_uniqueness_of :title

  validates_length_of :title, :caption, maximum: 50
  validates_length_of :link, maximum: 255
end
