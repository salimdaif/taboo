class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer  :sender_id
      t.integer  :recipient_id
      t.integer  :helpfulness
      t.integer  :response_time
      t.integer  :empathy
      t.text     :review
      t.timestamps
    end
    add_index :ratings, :sender_id
    add_index :ratings, :recipient_id
  end
end
