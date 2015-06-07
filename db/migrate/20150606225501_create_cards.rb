class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :title
      t.string :caption
      t.text :description
      t.string :link

      t.timestamps null: false
    end
  end
end
