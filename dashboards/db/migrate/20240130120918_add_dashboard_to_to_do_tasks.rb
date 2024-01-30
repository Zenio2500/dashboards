class AddDashboardToToDoTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :to_do_tasks, :dashboard, null: false, foreign_key: true
  end
end
