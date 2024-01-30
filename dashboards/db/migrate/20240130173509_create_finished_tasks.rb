class CreateFinishedTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :finished_tasks do |t|
      t.string :name
      t.date :finishDate, null: false

      t.timestamps
    end
  end
end
