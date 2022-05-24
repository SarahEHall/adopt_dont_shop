class UpdateStatusDefaultTo0Applications < ActiveRecord::Migration[5.2]
  def change
    change_column_default :applications, :status, default: 0
  end
end
