class PetApplication < ApplicationRecord
    belongs_to :pet
    belongs_to :application

    validates_presence_of :pet_id
    validates_presence_of :application_id
end