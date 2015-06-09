class ResponsesController < ApplicationController
  before_action :set_response, only: [:edit, :update]
  before_action :load_collections, only: [:new, :create, :edit, :update]

  def index
    @responses = Response.all
  end

  def new
    @response = Response.new
  end

  def edit
  end

  def create
    @response = Response.new(response_params)

    if @response.save
      redirect_to responses_path, notice: 'Response successfully created.'
    else
      render :new
    end
  end

  def update
    if @response.update(response_params)
      redirect_to responses_path, notice: 'Response successfully edited.'
    else
      render :edit
    end
  end

  private
  def set_response
    @response = Response.find(params[:id])
  end

  def load_collections
    @request_types = Response::REQUEST_TYPES
    @response_types = Response::TYPES
  end

  def response_params
    params.fetch(:response).permit(:response_type, :request_type, :content, :request_by)
  end
end
