class AddSeenIntroToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :seen_intro, :boolean, default: false
  end
end
