class ChangeStatusToBeIntegerInApplications < ActiveRecord::Migration[5.2]
  def change
    change_column :applications, :status, 'integer USING CAST(status AS integer)'
  end
end
