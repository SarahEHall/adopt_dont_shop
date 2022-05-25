require 'rails_helper'

RSpec.describe 'Application Show Page', type: :feature do
  let!(:shelter_1) { Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9) }

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
  let!(:pet_4) { shelter_1.pets.create(
    name: 'Annabelle', 
    breed: 'tuxedo shorthair', 
    age: 5, 
    adoptable: true) }
  let!(:pet_5) { shelter_1.pets.create(
    name: 'Annie', 
    breed: 'shorthair', 
    age: 3, 
    adoptable: true) }
  let!(:pet_6) { shelter_1.pets.create(
    name: 'Barbara Ann', 
    breed: 'ragdoll', 
    age: 3, 
    adoptable: false) }
  let!(:pet_7) { shelter_1.pets.create(
    name: 'Soup', 
    breed: 'box turtle', 
    age: 45, 
    adoptable: false) }


  let!(:application1) { Application.create!(
    name: 'Joe Exotic',
    street_address: '3150 Horton Rd',
    city: 'Fort Worth',
    state: 'TX',
    zip_code: 76119,
    description: 'I just really love animals',
    status: 3) }
  let!(:application2) { Application.create!(
    name: 'Carol Baskins',
    street_address: '12802 Easy St',
    city: 'Tampa',
    state: 'FL',
    zip_code: 33625,
    description: 'I just really love animals more than that other guy',
    status: 3) }
  let!(:application3) { Application.create!(
    name: 'Spongebob',
    street_address: '124 Conch lane',
    city: 'Bikini Bottom',
    state: 'Despair',
    zip_code: 33025,
    description: "I'm ready!",
    status: 0) }
  
  let!(:pet_application_1) { PetApplication.create!(pet: pet_1, application: application1) }
  let!(:pet_application_2) { PetApplication.create!(pet: pet_2, application: application2) }
  let!(:pet_application_3) { PetApplication.create!(pet: pet_3, application: application2) }

  describe 'visuals' do
    it 'can show attributes of the application' do
      visit "/applications/#{application1.id}"

      expect(page).to have_content(application1.name)
      expect(page).to have_content("Full address: 3150 Horton Rd, Fort Worth, TX 76119")
      expect(page).to have_content(application1.description)
      expect(page).to have_content(application1.status)

      expect(page).to_not have_content('Carol Baskins')
      expect(page).to_not have_content("Full address: 12802 Easy St, Tampa, fL 33625")
      expect(page).to_not have_content('I just really love animals more than that other guy')
      within "#appliedFor#{pet_1.id}" do
        click_link "#{pet_1.name}"
      end
      expect(current_path).to eq("/pets/#{pet_1.id}")
      expect(page).to have_content("Mr. Pirate")

      visit "/applications/#{application2.id}"

      within "#appliedFor#{pet_2.id}" do
        expect(page).to have_link("#{pet_2.name}")
      end
      within "#appliedFor#{pet_3.id}" do
        expect(page).to have_link("#{pet_3.name}")
      end
    end
  end

  it 'can test for multiple pets' do
    visit "/applications/#{application2.id}"
    expect(page).to have_content(application2.name)
    expect(page).to have_content("Full address: #{application2.street_address}, #{application2.city}, #{application2.state} #{application2.zip_code}")
    expect(page).to have_content(application2.description)
    expect(page).to have_content(application2.status)

    expect(page).to_not have_content(application1.name)

    click_link "#{pet_2.name}"
    expect(current_path).to eq("/pets/#{pet_2.id}")
    expect(page).to have_content(pet_2.name)

    visit "/applications/#{application2.id}"

    click_link "#{pet_3.name}"
    expect(current_path).to eq("/pets/#{pet_3.id}")
    expect(page).to have_content(pet_3.name)
  end

  describe 'Searching for Pets for an Application' do
    it 'has a search section that shows up on applications that are in progress' do
      visit "/applications/#{application1.id}"

      expect(page).to_not have_content("Add a Pet to this Application")


      visit "/applications/#{application3.id}"

      expect(page).to have_content("Add a Pet to this Application")
    end

    it 'returns a list of pets with an exact match to the name entered' do
      visit "/applications/#{application3.id}"

      fill_in(:search, with: "Clawdia")
      click_button("Submit")

      expect(page).to have_content("Clawdia")
      expect(page).to have_content("#{pet_2.breed}")
      expect(page).to have_content("#{pet_2.age}")

      expect(page).to_not have_content("#{pet_1.name}")
      expect(page).to_not have_content("#{pet_3.name}")

      within "#petEntry#{pet_2.id}" do
        expect(page).to have_content("Clawdia")
        expect(page).to have_content("#{pet_2.breed}")
        expect(page).to have_content("#{pet_2.age}")
        expect(page).to_not have_content("#{pet_1.name}")
        expect(page).to_not have_content("#{pet_3.name}")
      end
    end
  end

  describe 'Add a Pet to an Application' do
    it 'has a button to choose pet for adoption' do
      visit "/applications/#{application3.id}"
      expect(page).to have_content(application3.name)

      fill_in(:search, with: "Ann")
      click_button("Submit")

      within "#petEntry#{pet_3.id}" do
        click_button "Adopt #{pet_3.name}"
      end

      expect(current_path).to eq("/applications/#{application3.id}")
      expect(page).to have_link("#{pet_3.name}")
      expect(page).to_not have_content("Pet(s) applied for: #{pet_2.name}")
    end

    it 'can produce multiple matches' do
      visit "/applications/#{application3.id}"
      expect(page).to have_content(application3.name)

      fill_in(:search, with: "Ann")
      click_button("Submit")

      expect(page).to have_content(pet_3.name)
      expect(page).to have_content(pet_4.name)
      expect(page).to have_content(pet_5.name)
      expect(page).to have_content(pet_6.name)
      expect(page).to_not have_content(pet_7.name)


      # application2.pets.each do |pet|
      #   expect(page).to have_content(pet.name) Why can we not use this?
      # end

    end
  end

  describe 'Application submission form' do
    it 'shows up when application has pets and does not show up when application has no pets' do
      visit "/applications/#{application3.id}"
      expect(page).to have_content(application3.name)
      expect(page).to_not have_content("Please enter why you would make a good home for these pet(s)")

      PetApplication.create!(pet: pet_6, application: application3)

      visit "/applications/#{application3.id}"

      expect(page).to have_content("Please enter why you would make a good home for these pet(s)")
    end

    it 'changes application status to pending when submitted' do
      PetApplication.create!(pet: pet_6, application: application3)

      visit "/applications/#{application3.id}"

      fill_in(:description, with: "I'm ready!")

      click_on("Submit Application")

      expect(page).to have_current_path("/applications/#{application3.id}")
      expect(page).to have_content("Application Status: Pending")
      expect(page).to_not have_content("Add a Pet to this Application")
      expect(page).to have_link("#{pet_6.name}")
    end
  end

  describe 'wonky matches for pet search' do 
    it 'can return pets whose name partially matches a search' do
      visit "/applications/#{application3.id}"

      fill_in(:search, with: "Ann")
      click_button("Submit")

      expect(page).to have_content("Annabelle")
      expect(page).to have_content("Ann")
      expect(page).to have_content("Barbara Ann")
      expect(page).to_not have_content("Soup")

      visit "/applications/#{application3.id}"
      fill_in(:search, with: "n")
      click_button("Submit")

      expect(page).to have_content("Annabelle")
      expect(page).to have_content("Ann")
      expect(page).to have_content("Barbara Ann")
      expect(page).to_not have_content("Soup")
    end
    
    it 'produces results even if case is different' do
      visit "/applications/#{application3.id}"

      fill_in(:search, with: "aNn")
      click_button("Submit")

      expect(page).to have_content("Annabelle")
      expect(page).to have_content("Ann")
      expect(page).to have_content("Barbara Ann")
      expect(page).to_not have_content("Soup")

      visit "/applications/#{application3.id}"
      fill_in(:search, with: "ANN")
      click_button("Submit")

      expect(page).to have_content("Annabelle")
      expect(page).to have_content("Ann")
      expect(page).to have_content("Barbara Ann")
      expect(page).to_not have_content("Soup")
    end
  end
end
