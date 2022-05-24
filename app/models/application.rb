class Application < ApplicationRecord   
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  validates_presence_of :name, :street_address, :city, :state 
  validates :zip_code, length: {is: 5}
  enum status:["In Progress", "Pending", "Accepted", "Rejected"]
end