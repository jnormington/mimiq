class ScenarioController < ApplicationController
  def index
    @cards = Card.all
  end

  def timeout
    sleep((params[:time] || 5).to_i)
    @example_url = timeout_scenario_url(time: rand(1..60))
  end

  def not_found
    render file: 'public/404.html',  status: 404
  end

  def server_error
    render file: 'public/500.html',  status: 500
  end

  def get
    ResponseHandler.new(self, action_name, params[:request_by]).resolve
  end
end
