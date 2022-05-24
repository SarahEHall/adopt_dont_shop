class UpdateStatusDefaultTo0PetApplications < ActiveRecord::Migration[5.2]
  def change
    change_column_default :pet_applications, :status, from: nil, to: 0
  end
end
