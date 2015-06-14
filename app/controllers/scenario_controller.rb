class ScenarioController < ApplicationController
  before_action :load_response, only: [:get, :post]

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
    sleep_time if params[:from_action].blank?
    ResponseHandler.new(self, (params[:from_action] ||= action_name), params[:request_by]).resolve
  end

  def post
    sleep_time
    redirect_to get_scenario_path(params[:request_by], from_action: 'post')
  end

  private

  def load_response
    @response ||= Response.where(request_type: action_name.upcase).find_by(request_by: params[:request_by])
  end

  def sleep_time
    sleep(@response.try(:wait_time).to_i)
  end
end
