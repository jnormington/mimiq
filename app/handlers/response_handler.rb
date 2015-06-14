class ResponseHandler
  attr_reader :controller

  def initialize(controller, response)
    @controller = controller
    @response = response
  end

  def resolve
    case response.response_type
    when '404', '500'
      send("respond_with_#{response.response_type}")
    else
      respond_with(response)
    end
  end

  def response
    @response ||= Response.new(response_type: '404')
  end

  private

  def respond_with_500
    controller.render file: 'public/500.html',  status: 500
  end

  def respond_with_404
    controller.render file: 'public/404.html',  status: 404
  end

  def respond_with(response)
    status = Integer(response.response_type.split('_').first) rescue nil
    content_type = response.response_type.match(/XML|JSON/).to_s.downcase

    params = { body: response.content, content_type: "application/#{content_type}" }
    params.merge!(status: status) if status

    controller.render params
  end
end
