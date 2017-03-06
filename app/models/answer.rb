class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  validates :content, length: { minimum: 1 }

  scope :sum_of_content, -> { all.map(&:content).inject(:+).try(:length).to_i }
end
