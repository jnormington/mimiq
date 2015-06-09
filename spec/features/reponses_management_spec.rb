require 'rails_helper'

describe 'Responses', type: :feature do
  let(:success_create) { 'Response successfully created' }

  describe 'Index page' do
    let!(:reponse) { Response.create!(response_type: 'XML', content: 'some content', request_type: 'GET', request_by: 'test')}

    it 'displays a table with responses' do
      visit responses_path
      row = table_row_for('XML')

      expect(row).not_to be_nil
      expect(row.text).to have_text 'some content'
      expect(row.text).to have_text 'XML'
      expect(row.text).to have_text 'GET'
    end
  end

  describe 'Creating'do
    let!(:response) {{ response_type: 'XML', content: 'some fake xml', request_type: 'GET', request_by: 'something' }}
    let(:response_a) {{response_type: 'XML',  content: 'some fake xml',    request_type: 'GET', request_by: '' }}
    let(:response_b) {{response_type: 'JSON', content: '{some fake json}', request_type: 'GET', request_by: '' }}

    it 'creates successfully and redirects to index page' do
      visit_index_and_click_create_resource
      fill_in_response_form_with response

      expect(page).to have_text success_create

      row = table_row_for('something')
      expect(row).not_to be_nil
      expect(row.text).to have_text 'some fake xml'
      expect(row.text).to have_text 'XML'
      expect(row.text).to have_text 'GET'
      expect(row.text).to have_text 'something'
    end

    it 'returns to the response index page and doesnt save' do
      visit_index_and_click_create_resource
      fill_in_response_form_with response, nil, false

      click_link 'Back'

      expect { table_row_for('something') }.to raise_error(Capybara::ElementNotFound)
    end

    it "displays errors when response input is invalid" do
      visit_index_and_click_create_resource
      fill_in_response_form_with {}

      expect(page).to have_text '1 error occurred'
      expect(page).to have_text "Content can't be blank"
    end

    it "remembers my response_type and request_type selection when errors occur" do
      visit_index_and_click_create_resource
      fill_in_response_form_with({request_type: 'POST', response_type: 'JSON'})

      fill_in_response_form_with({content: 'blah'})

      response = Response.last

      expect(response.request_type).to eq 'POST'
      expect(response.response_type).to eq 'JSON'
    end

    ['GET', 'POST'].each do |request_type|
      it "doesn't display an error when leaving request_by blank for #{request_type} and one exists for the other request_type" do
        rt = ['GET', 'POST']
        rt.delete(request_type)

        response_a.merge!(request_type: rt.first)
        response_b.merge!(request_type: request_type)

        visit_index_and_click_create_resource
        fill_in_response_form_with response_a

        expect(page).to have_text success_create

        visit_index_and_click_create_resource
        fill_in_response_form_with response_b
        expect(page).to have_text success_create
      end


      it "displays an error when leaving request_by blank and one already exists for #{request_type}" do
        response_a.merge!(request_type: request_type)
        response_b.merge!(request_type: request_type)

        visit_index_and_click_create_resource
        fill_in_response_form_with response_a

        expect(page).to have_text success_create

        visit_index_and_click_create_resource
        fill_in_response_form_with response_b

        expect(page).to have_text '1 error occurred'
        expect(page).to have_text "Request by has already been taken"
      end
    end

    describe 'Editing' do
      let(:response_a)      {{ response_type: '500',  content: 'some json content', request_type: 'GET',  request_by: ''}}
      let(:response)        {{ response_type: 'XML',  content: 'some fake xml',     request_type: 'GET',  request_by: 'bread' }}
      let(:edited_response) {{ response_type: 'JSON', content: 'some json',         request_type: 'POST', request_by: 'butter' }}
      let(:success_edit)    { 'Response successfully edited' }

      it 'saves and displays the response with the edited details' do
        visit_index_and_click_create_resource
        fill_in_response_form_with response

        expect(page).to have_text success_create
        expect(table_row_for('bread').text).to eq 'GET XML bread some fake xml Edit'

        within table_row_for('bread') do
          click_link 'Edit'
        end

        expect(page).to have_text 'Edit Response'
        fill_in_response_form_with edited_response, 'Update'
        expect(page).to have_text success_edit

        expect(table_row_for('butter').text).to eq 'POST JSON butter some json Edit'
      end

      it 'displays errors when removing content and request_by and it exists' do
        [response, response_a].each {|res| Response.create!(res) }

        visit responses_path

        within(table_row_for('some fake xml')) do
          click_link 'Edit'
        end

        fill_in_response_form_with({content: '', request_by: ''}, 'Update')
        expect(page).to have_text '2 errors'
        expect(page).to have_text 'Request by has already been taken'
        expect(page).to have_text "Content can't be blank"
      end
    end
  end

  def visit_index_and_click_create_resource
    visit responses_path
    click_link 'Create Response'
  end

  def fill_in_response_form_with(response = {}, create_or_update = 'Create', save = true)
    fill_in 'Request by', with: response[:request_by]
    fill_in 'Content', with: response[:content]

    if response[:request_type]
      select response[:request_type], from: 'response_request_type'
    end

    if response[:response_type]
      select response[:response_type], from: 'response_response_type'
    end

    click_button create_or_update if save
  end

  def table_row_for(value)
    find(:xpath, "//table/tbody/tr[contains(.,'#{value}')]")
  end
end
