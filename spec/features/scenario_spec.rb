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

