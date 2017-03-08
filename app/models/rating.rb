class Rating < ApplicationRecord
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'

  RATING = [ 1, 2, 3, 4, 5]

  validates :helpfulness, :empathy, :response_time, inclusion: { in: RATING}
end
