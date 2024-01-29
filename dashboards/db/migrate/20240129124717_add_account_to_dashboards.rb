class AddAccountToDashboards < ActiveRecord::Migration[7.1]
  def change
    add_reference :dashboards, :account, null: false, foreign_key: true
  end
end
