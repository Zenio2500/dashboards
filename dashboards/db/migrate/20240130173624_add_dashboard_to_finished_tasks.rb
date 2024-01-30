class AddDashboardToFinishedTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :finished_tasks, :dashboard, null: false, foreign_key: true
  end
end
