class CreateToDoTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :to_do_tasks do |t|
      t.string :name

      t.timestamps
    end
  end
end
