require 'rails_helper'

describe 'Viewing scenario index page', type: :feature do
  describe "without any cards" do
    it "displays the scenario index page when no cards exists" do
      visit scenario_path
      expect(page).to have_text 'Available Pages'
    end
  end

  describe "with cards" do
    let!(:card_a) { Card.create!(title: 'Timeout', caption: 'Caption me', description: 'Blah timeout', link: '/timeout')}
    let(:card_b)  { Card.create!(title: 'HelperC', caption: 'Help me',    description: 'Blah help',    link: '/help')}

    it "displays the card on the index page" do
      visit scenario_path
      expect(page).to have_text 'Timeout'
      expect(page).to have_text 'Caption me'
      expect(page).to have_text 'Blah timeout'
      expect(find_link('Timeout')['href']).to eq '/timeout'

      expect(page).not_to have_text 'HelperC'
    end

    it "displays multiple cards on the index page" do
      card_b
      visit scenario_path
      expect(page).to have_text 'Timeout'

      expect(page).to have_text 'HelperC'
      expect(page).to have_text 'Help me'
      expect(page).to have_text 'Blah help'
      expect(find_link('HelperC')['href']).to eq '/help'
    end
  end
end

describe 'Viewing scenario custom show page', type: :feature do
  let!(:card_a) { Card.create!(title: 'Timeout', caption: 'Caption me', description: 'Blah timeout', link: '/scenario/timeout')}

  describe 'Timeout scenario' do
    it 'displays card with detail and go home link' do
      visit scenario_path
      click_link 'Timeout'

      expect(page).to have_text "Don't forget"
      expect(find_link('Go home')['href']).to eq '/'

      click_link 'Go home'
      expect(page).to have_text 'Welcome to Mimiq'
    end
  end
end

describe '#get scenario' do
  let!(:response_a) do
    Response.create!(
      request_type: 'GET',
      request_by: 'pst1',
      response_type: 'JSON',
      content: '{postcodes: []}'
    )
  end

  let!(:response_b) do
    Response.create!(
      request_type: 'GET',
      request_by: 'pst_err',
      response_type: '500',
      content: '{postcodes: []}'
    )
  end

  let!(:response_wait) do
    Response.create!(
      request_type: 'GET',
      request_by: 'wait_e',
      response_type: '422_JSON',
      content: '{postcodes: []}',
      wait_time: '3'
    )
  end

  it 'returns the content of response when request_by provided' do
    visit get_scenario_path('pst1')

    expect(page.status_code).to eq 200
    expect(page.source).to eq response_a.content
    expect(page.response_headers["Content-Type"]).to include 'application/json'
  end

  it "returns a 404 page when no record can be found" do
    visit get_scenario_path('blah')

    expect(page.status_code).to eq 404
    expect(page).to have_text "The page you were looking for doesn't exist (404)"
  end

  it "returns a 500 page when response states to return a 500" do
    visit get_scenario_path('pst_err')

    expect(page.status_code).to eq 500
    expect(page).to have_text "We're sorry, but something went wrong (500)"
  end

  it 'waits for the specified time on the response' do
    start_time = Time.now
    visit get_scenario_path('wait_e')
    finish_time = Time.now

    expect(finish_time.to_i - start_time.to_i).to eq 3
    expect(page.status_code).to eq 422
    expect(page.source).to eq response_b.content
    expect(page.response_headers["Content-Type"]).to include 'application/json'
  end

  it 'waits for 0 seconds when wait_time is nil' do
    start_time = Time.now
    visit get_scenario_path('pst1')
    finish_time = Time.now

    expect(finish_time.to_i - start_time.to_i).to eq 0
    expect(page.source).to eq response_a.content
    expect(page.response_headers["Content-Type"]).to include 'application/json'
  end
end

describe '#post scenario' do
  let!(:response_a) do
    Response.create!(
      request_type: 'POST',
      request_by: 'bug',
      response_type: '500',
      content: 'frog'
    )
  end

  let!(:response_b) do
    Response.create!(
      request_type: 'POST',
      request_by: 't_rex',
      response_type: 'XML',
      content: '<xml></xml>'
    )
  end

  let!(:response_c) do
    Response.create!(
      request_type: 'POST',
      request_by: 'error',
      response_type: '422_JSON',
      content: "{errors: ['email required']}"
    )
  end

  let!(:response_d) do
    Response.create!(
      request_type: 'GET',
      request_by: 'free',
      response_type: 'XML',
      content: "{errors: ['email required']}",
      wait_time: '4'
    )
  end

  let!(:response_e) do
    Response.create!(
      request_type: 'POST',
      request_by: 'free',
      response_type: 'XML',
      content: "{errors: ['email required']}",
      wait_time: '2'
    )
  end

  it 'waits for the specified time on the response when a matching GET response matches request_by' do
    start_time = Time.now
    page.driver.follow(:post, post_scenario_path('free'), params: { :anything => "AAXZK" })
    finish_time = Time.now

    expect(finish_time.to_i - start_time.to_i).to eq 2
    expect(page.status_code).to eq 200
    expect(page.source).to eq response_e.content
    expect(page.response_headers["Content-Type"]).to include 'application/xml'
  end

  it 'waits for 0 seconds when wait_time is nil' do
    start_time = Time.now
    page.driver.follow(:post, post_scenario_path('bug'), params: { :anything => "AAXZK" })
    finish_time = Time.now

    expect(finish_time.to_i - start_time.to_i).to eq 0
    expect(page.status_code).to eq 500
    expect(page).to have_text "We're sorry, but something went wrong (500)"
  end

  it 'returns the content of response content when request_by is provided' do
    page.driver.follow(:post, post_scenario_path('t_rex'), params: { :anything => "AAXZK" })

    expect(page.status_code).to eq 200
    expect(page.source).to eq response_b.content
    expect(page.response_headers["Content-Type"]).to include 'application/xml'
  end

  it 'returns the json content type and 422 http status' do
    page.driver.follow(:post, post_scenario_path('error'), params: { :not_even_required => "ACZK" })

    expect(page.status_code).to eq 422
    expect(page.source).to eq response_c.content
    expect(page.response_headers["Content-Type"]).to include 'application/json'
  end

  it "returns a 404 page when no record can be found" do
    page.driver.follow(:post, post_scenario_path('boo'), params: { :something => "AAXZK" })

    expect(page.status_code).to eq 404
    expect(page).to have_text "The page you were looking for doesn't exist (404)"
  end

  it "returns a 500 page when response states to return a 500" do
    page.driver.follow(:post, post_scenario_path('bug'), params: {test: 't'})

    expect(page.status_code).to eq 500
    expect(page).to have_text "We're sorry, but something went wrong (500)"
  end
end
