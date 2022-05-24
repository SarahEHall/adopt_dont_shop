require 'rails_helper'

RSpec.describe Application, type: :model do 
    describe 'relationships' do 
        it { should have_many :pet_applications }
        it { should have_many(:pets).through(:pet_applications) }
    end

    describe 'validations' do 
      it { should validate_presence_of :name }
      it { should validate_presence_of :street_address }
      it { should validate_presence_of :city }
      it { should validate_presence_of :state }
      it { should validate_length_of :zip_code => 5 }
      it { should allow_value("In Progress").for(:status) }
      it { should allow_value("Pending").for(:status) }
      it { should allow_value("Accepted").for(:status) }
      it { should allow_value("Rejected").for(:status) }
    end
end