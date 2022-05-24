class ChangeStatusToBeIntegerInPetApplications < ActiveRecord::Migration[5.2]
  def change
    change_column :pet_applications, :status, 'integer USING CAST(status AS integer)'
  end
end
