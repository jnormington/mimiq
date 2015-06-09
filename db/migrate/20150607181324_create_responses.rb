class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :request_type
      t.string :request_by
      t.string :response_type
      t.text   :content

      t.timestamps null: false
    end
  end
end
