class AddDashboardToInProgressTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :in_progress_tasks, :dashboard, null: false, foreign_key: true
  end
end
