class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  require 'typhoeus'
  require 'json'
  has_many :sent_ratings, :foreign_key => :sender_id, class_name: 'Rating'
  has_many :ratings, :foreign_key => :recipient_id
  has_many :answers, dependent: :destroy
  has_many :questions, through: :answers
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 18, less_than: 120 }

  before_save :default_values
  def default_values
    self.avatar ||= '/avatar/001.png'
  end


  def unanswered_questions
    Question.where.not(id: self.questions.map(&:id)).sample
  end

  def answered_minimum_questions?
    answers.sum_of_content >= 100 ? true : false
  end

  def percentage
    if (( answers.sum_of_content / 100.0 ) * 100) <= 100
      (( answers.sum_of_content / 100.0 ) * 100).to_s
    else
      100
    end
  end

  def init_answers
    File.open("tmp/answer_user_#{self.id}.txt","w") do |line|

      questions.each do |question|
        line.puts question.content
        question.answers.each do |answer|
          line.puts answer.content
        end
      end
    end
  end

  def get_insight

    init_answers

    response = Typhoeus::Request.post("https://gateway.watsonplatform.net/personality-insights/api/v3/profile?version=2016-10-20",
                  :username => "43fa94b8-8cf7-45fc-b4bf-1f5ac7e04a3e",
                  :password => "JT1dpggnYMfR",
                  :headers => {'Content-Type' => 'text/plain;charset=utf-8'},
                  :body => {'data-binary' => File.open("tmp/answer_user_#{self.id}.txt")})
    self.insight = JSON.parse(response.response_body)
    self.save!
  end

  def print_insight
    insight_hash = {}
    unless self.insight.nil?
      unless self.insight["personality"].nil?
        (0..4).to_a.each do |i|
          (0..5).to_a.each do |j|
            insight_hash[self.insight["personality"][i]["children"][j]["name"]] = (self.insight["personality"][i]["children"][j]["percentile"] * 100).round
          end
        end
      end
      unless self.insight["values"].nil?
        (0..4).to_a.each do |k|
          insight_hash[self.insight["values"][k]["name"]] = (self.insight["values"][k]["percentile"] *100).round
        end
      end
    end
    insight_hash
  end

  def add_scores
    matches_hash = {}

    User.where.not(id: self.id).each do |user|
      matches_hash[user.id] = calculate_score(user)
    end

    matches_hash
  end

  def calculate_score(user)
    origin = self
    target = user
    score = 0.0

    origin_traits = origin.print_insight
    target_traits = target.print_insight

    target_traits.each do |k,value|
      score += 100 - ( value - origin_traits[k]).abs
    end

    score = (score / target_traits.count ).round

  end


  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  def overall_rating
    scores = []
    self.ratings.each do |rating|
      scores << ((rating.helpfulness.to_f + rating.response_time.to_f + rating.empathy.to_f) / 3.0)
     end
     (scores.inject(&:+) / scores.length.to_f)
  end

  def online?
    if ((DateTime.current - self.last_sign_in_at.to_datetime).to_i * 24) < 5
      true
    else
      false
    end
  end

end
