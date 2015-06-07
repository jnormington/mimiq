require 'rails_helper'

describe 'Viewing home page', type: :feature do
  describe "without any cards" do
    it "displays the home page when no cards exists" do
      visit root_path
      expect(page).to have_text 'Welcome to Mimiq'
      expect(page).to have_text 'Available Pages'
    end
  end

  describe "with cards" do
    let!(:card_a) { Card.create!(title: 'Timeout', caption: 'Caption me', description: 'Blah timeout', link: '/timeout')}
    let(:card_b)  { Card.create!(title: 'HelperC', caption: 'Help me',    description: 'Blah help',    link: '/help')}

    it "displays the card on the home page" do
      visit root_path
      expect(page).to have_text 'Timeout'
      expect(page).to have_text 'Caption me'
      expect(page).to have_text 'Blah timeout'
      expect(find_link('Timeout')['href']).to eq '/timeout'

      expect(page).not_to have_text 'HelperC'
    end

    it "displays both cards on the home page" do
      card_b #activate it
      visit root_path
      expect(page).to have_text 'Timeout'

      expect(page).to have_text 'HelperC'
      expect(page).to have_text 'Help me'
      expect(page).to have_text 'Blah help'
      expect(find_link('HelperC')['href']).to eq '/help'
    end
  end
end
