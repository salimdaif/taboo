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
    if (( answers.sum_of_content / 500.0 ) * 100) <= 100
      (( answers.sum_of_content / 500.0 ) * 100).to_s
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

  def add_scores
    big_hash = {}

    User.where.not(id: self.id).each do |user|
      big_hash[user.id.to_sym] = current_user.calculate_score(user)
    end

    big_hash
  end

  def calculate_score(user)
    origin = self
    target = user

    origin_traits = {}

    (0..5).to_a.each do |i|
      origin_traits[origin.insight["personality"][0]["children"][i]["name"]] = origin.insight["personality"][0]["children"][i]["percentile"]
    end

    target_traits ={}

    (0..5).to_a.each do |i|
      target_traits[target.insight["personality"][0]["children"][i]["name"]] = target.insight["personality"][0]["children"][i]["percentile"]
    end

    score = 0
      byebug
    score += (target_traits["Adventurousness"] - origin_traits["Adventurousness"]).abs
  end
end
