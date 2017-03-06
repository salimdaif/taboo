class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :answers
  has_many :questions, through: :answers
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 18, less_than: 120 }

  def unanswered_questions
    Question.where.not(id: self.questions.map(&:id)).sample
  end

  def answered_minimum_questions?
    answers.sum_of_content >= 500 ? true : false
  end

  def percentage
    (( answers.sum_of_content / 500.0 ) * 100).to_s + "%"
  end
end
