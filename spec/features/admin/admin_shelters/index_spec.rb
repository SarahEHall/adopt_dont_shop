require 'rails_helper'

RSpec.describe 'admin shelters index', type: :feature do
  let!(:shelter_1) { Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9) }
  let!(:shelter_2) { Shelter.create!(name: 'Boulder shelter', city: 'Boulder, CO', foster_program: false, rank: 9) }
  let!(:shelter_3) { Shelter.create(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 7) }

  let!(:pet_1) { shelter_1.pets.create!(
    name: 'Mr. Pirate', 
    breed: 'tuxedo shorthair', 
    age: 5, 
    adoptable: true) }
  let!(:pet_2) { shelter_1.pets.create!(
    name: 'Clawdia', 
    breed: 'shorthair', 
    age: 3, 
    adoptable: true) }
  let!(:pet_3) { shelter_1.pets.create!(
    name: 'Ann', 
    breed: 'ragdoll', 
    age: 3, 
    adoptable: false) }
  let!(:pet_4) { shelter_2.pets.create!(
    adoptable: true, 
    age: 1, 
    breed: 'orange tabby shorthair', 
    name: 'Lasagna') }
  let!(:pet_5) { shelter_2.pets.create!(
    adoptable: true, 
    age: 1, 
    breed: 'sphynx', 
    name: 'Lucille Bald') }
  let!(:pet_6) { shelter_3.pets.create!(
    adoptable: true, 
    age: 3, 
    breed: 'doberman', 
    name: 'Lobster') }
  let!(:pet_7) { shelter_3.pets.create!(
    adoptable: false, 
    age: 2, 
    breed: 'saint bernard', 
    name: 'Beethoven') }

  let!(:application1) { Application.create!(
    name: 'Joe Exotic',
    street_address: '3150 Horton Rd',
    city: 'Fort Worth',
    state: 'TX',
    zip_code: 76119,
    description: 'I just really love animals',
    status: 'Rejected') }
  let!(:application2) { Application.create!(
    name: 'Spongebob',
    street_address: '123 Conch Ln',
    city: 'Bikini Bottom',
    state: 'Despair',
    zip_code: 42500,
    description: 'RIP Gary, need a new one',
    status: 'Pending') }
  let!(:application3) { Application.create!(
    name: 'Steve Irwin',
    street_address: '1111 Heaven St',
    city: 'Sydney',
    state: 'NSW-AU',
    zip_code: 20000,
    description: 'Big fan of animals.',
    status: 'Pending')}
  let!(:application4) { Application.create!(
    name: 'Mister Rogers',
    street_address: '1 MakeBelieve court',
    city: 'Toronto',
    state: 'Ontario',
    zip_code: 66777,
    description: 'I just wanna shine a little light in their little lives.',
    status: 'Pending') }

    let!(:pet_application_1) { PetApplication.create!(pet: pet_1, application: application1) }
    let!(:pet_application_2) { PetApplication.create!(pet: pet_2, application: application2) }
    let!(:pet_application_3) { PetApplication.create!(pet: pet_3, application: application2) }
    let!(:pet_application_6) { PetApplication.create!(pet: pet_1, application: application3) }
    let!(:pet_application_7) { PetApplication.create!(pet: pet_4, application: application4) }
    let!(:pet_application_8) { PetApplication.create!(pet: pet_2, application: application4) }
    let!(:pet_application_9) { PetApplication.create!(pet: pet_4, application: application4) }
    let!(:pet_application_10){ PetApplication.create!(pet: pet_5, application: application3) }

  describe 'SQL only story' do 
    it 'has raw SQL for admin shelters query for reverse alphabetical order' do 
      visit '/admin/shelters'

      within "#orderedShelters" do 
        expect(shelter_3.name).to appear_before(shelter_2.name)
        expect(shelter_2.name).to appear_before(shelter_1.name)
      end 
    end
  end
  describe 'Shelters with Pending Applications' do 
    it 'has a section for pending applications' do 
      visit '/admin/shelters'
      expect(page).to have_content(shelter_1.name)
      expect(page).to have_content(shelter_2.name)
      expect(page).to have_content(shelter_3.name)

      within "#pendingApplications" do 
        expect(page).to have_content("Shelter's with Pending Applications")
        expect(page).to have_content(shelter_1.name)
        expect(page).to have_content(shelter_2.name)
        expect(page).to_not have_content(shelter_3.name)
      end
    end
  end
end