class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  require 'typhoeus'
  require 'json'
  has_many :sent_ratings, :foreign_key => :sender_id, class_name: 'Rating'
  has_many :ratings, :foreign_key => :recipient_id
  has_many :answers
  has_many :questions, through: :answers
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 18, less_than: 120 }

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

    origin_traits = {}

   unless target.insight.nil?
    unless target.insight["personality"].nil?
      (0..4).to_a.each do |i|
        (0..5).to_a.each do |j|
          origin_traits[origin.insight["personality"][i]["children"][j]["name"]] = origin.insight["personality"][i]["children"][j]["percentile"]
        end
      end
    end
  end
    target_traits ={}


  unless target.insight.nil?
    unless target.insight["personality"].nil?
    (0..4).to_a.each do |i|
      (0..5).to_a.each do |j|
        target_traits[target.insight["personality"][i]["children"][j]["name"]] = target.insight["personality"][i]["children"][j]["percentile"]
      end
    end

    score += 1 - (target_traits["Adventurousness"] - origin_traits["Adventurousness"]).abs
    score += 1 - (target_traits["Artistic interests"] - origin_traits["Artistic interests"]).abs
    score += 1 - (target_traits["Emotionality"] - origin_traits["Emotionality"]).abs
    score += 1 - (target_traits["Imagination"] - origin_traits["Imagination"]).abs
    score += 1 - (target_traits["Intellect"] - origin_traits["Intellect"]).abs
    score += 1 - (target_traits["Authority-challenging"] - origin_traits["Authority-challenging"]).abs
    score += 1 - (target_traits["Achievement striving"] - origin_traits["Achievement striving"]).abs
    score += 1 - (target_traits["Cautiousness"] - origin_traits["Cautiousness"]).abs
    score += 1 - (target_traits["Dutifulness"] - origin_traits["Dutifulness"]).abs
    score += 1 - (target_traits["Orderliness"] - origin_traits["Orderliness"]).abs
    score += 1 - (target_traits["Self-discipline"] - origin_traits["Self-discipline"]).abs
    score += 1 - (target_traits["Self-efficacy"] - origin_traits["Self-efficacy"]).abs
    score += 1 - (target_traits["Activity level"] - origin_traits["Activity level"]).abs
    score += 1 - (target_traits["Assertiveness"] - origin_traits["Assertiveness"]).abs
    score += 1 - (target_traits["Cheerfulness"] - origin_traits["Cheerfulness"]).abs
    score += 1 - (target_traits["Excitement-seeking"] - origin_traits["Excitement-seeking"]).abs
    score += 1 - (target_traits["Outgoing"] - origin_traits["Outgoing"]).abs
    score += 1 - (target_traits["Gregariousness"] - origin_traits["Gregariousness"]).abs
    score += 1 - (target_traits["Altruism"] - origin_traits["Altruism"]).abs
    score += 1 - (target_traits["Cooperation"] - origin_traits["Cooperation"]).abs
    score += 1 - (target_traits["Uncompromising"] - origin_traits["Uncompromising"]).abs
    score += 1 - (target_traits["Sympathy"] - origin_traits["Sympathy"]).abs
    score += 1 - (target_traits["Trust"] - origin_traits["Trust"]).abs
    score += 1 - (target_traits["Fiery"] - origin_traits["Fiery"]).abs
    score += 1 - (target_traits["Prone to worry"] - origin_traits["Prone to worry"]).abs
    score += 1 - (target_traits["Melancholy"] - origin_traits["Melancholy"]).abs
    score += 1 - (target_traits["Immoderation"] - origin_traits["Immoderation"]).abs
    score += 1 - (target_traits["Self-consciousness"] - origin_traits["Self-consciousness"]).abs
    score += 1 - (target_traits["Susceptible to stress"] - origin_traits["Susceptible to stress"]).abs

    score = (score/29)*100
    score = score.round

    score

    end
  end
    score
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
