class CreateInProgressTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :in_progress_tasks do |t|
      t.string :name

      t.timestamps
    end
  end
end
