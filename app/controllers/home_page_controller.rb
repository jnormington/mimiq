class HomePageController < ApplicationController
  def show
    @cards = Card.all
  end
end
