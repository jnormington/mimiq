require 'rails_helper'

class FakeController
  def render(args = {})
    args.merge(render: true)
  end
end

describe 'ResponseHandler' do
  let(:controller) { FakeController.new }
  let(:subject) { ResponseHandler.new(controller, 'get', 'postcode') }

  describe 'initialize' do
    it 'expects controller instance is intialized' do
      expect(subject.controller).to eq controller
    end

    it 'expects action name is intialized' do
      expect(subject.action).to eq 'get'
    end

    it 'expects request_by instance is intialized' do
      expect(subject.request_by).to eq 'postcode'
    end
  end

  describe '#resolve' do
    let(:response_500) do Response.new(
      request_type: 'get',
      response_type: '500',
      request_by: 'blue',
      content: 'grhh')
    end

    let(:response_404) do Response.new(
      request_type: 'get',
      response_type: '404',
      request_by: 'black',
      content: 'blah')
    end

    let(:response_xml) do Response.new(
      request_type: 'get',
      response_type: 'XML',
      request_by: 'yellow',
      content: '<xml></xml>')
    end

    let(:response_json) do Response.new(
      request_type: 'get',
      response_type: 'JSON',
      request_by: 'green',
      content: '{postcode: AA1 1CU}')
    end

    let(:response_422_json) do Response.new(
      request_type: 'get',
      response_type: '422_JSON',
      request_by: 'green',
      content: '{errors: []}')
    end

    let(:response_422_xml) do Response.new(
      request_type: 'get',
      response_type: '422_XML',
      request_by: 'green',
      content: '{errors: []}')
    end

    it 'expects to render 500 status page' do
      allow(subject).to receive(:find_response) { response_500 }
      expect(subject.resolve).to eq({ file: "public/500.html",  status: 500, render: true })
    end

    it 'expects to render 404 status page' do
      allow(subject).to receive(:find_response) { response_404 }
      expect(subject.resolve).to eq({ file: "public/404.html",  status: 404, render: true })
    end

    it 'expects to render xml body and content type' do
      allow(subject).to receive(:find_response) { response_xml }
      expect(subject.resolve).to eq({
        body: response_xml.content,
        content_type: 'application/xml',
        render: true
      })
    end

    it 'expects to render json body and content type' do
      allow(subject).to receive(:find_response) { response_json }
      expect(subject.resolve).to eq({
        body: response_json.content,
        content_type: 'application/json',
        render: true
      })
    end

    it 'expects to render 422 with XML content_type' do
      allow(subject).to receive(:find_response) { response_422_xml }
      expect(subject.resolve).to eq({
        body: response_422_xml.content,
        content_type: 'application/xml',
        status: 422,
        render: true
      })
    end

    it 'expects to render 422 with JSON content_type' do
      allow(subject).to receive(:find_response) { response_422_json }
      expect(subject.resolve).to eq({
        body: response_422_json.content,
        content_type: 'application/json',
        status: 422,
        render: true
      })
    end

    it 'expects to render 404 when record is not found' do
      allow(subject).to receive(:find_response) { Response.new(response_type: '404') }
      expect(subject.resolve).to eq({ file: "public/404.html",  status: 404, render: true })
    end
  end
end
