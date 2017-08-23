require 'rails_helper'

RSpec.feature "Cars", type: :feature do
    scenario 'User views the /cars page' do
        visit '/cars'
        expect(page).to have_text('Cars')
        expect(page).to have_text('Toyota')
    end
end
