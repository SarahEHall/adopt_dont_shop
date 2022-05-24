class UpdateStatusDefaultTo0Applications2 < ActiveRecord::Migration[5.2]
  def change
    change_column_default :applications, :status, from: nil, to: 0
  end
end
