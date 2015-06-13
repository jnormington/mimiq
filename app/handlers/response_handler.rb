class ResponseHandler
  attr_reader :controller, :action, :request_by

  def initialize(controller, action, request_by)
    @controller = controller
    @action = action
    @request_by = request_by

  end

  def resolve
    case response
    when nil
      respond_with_404
    else
      send("respond_with_#{response.response_type.downcase}")
    end
  end

  private
  def find_response
    Response.where(request_type: action).find_by(request_by: request_by)
  end

  def response
    @response ||= find_response
  end

  def respond_with_500
    controller.render file: 'public/500.html',  status: 500
  end

  def respond_with_404
    controller.render file: 'public/404.html',  status: 404
  end

  def respond_with_xml
    controller.render body: response.content, content_type: 'application/xml'
  end

  def respond_with_json
    controller.render body: response.content, content_type: 'application/json'
  end
end
