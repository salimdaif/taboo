# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Question.destroy_all

Question.create(content: "What scares you the most?")
Question.create(content: "What would you do if you had 24h left to live?")
Question.create(content: "What are you ashamed of?")
Question.create(content: "What have you/are you struggling with?")
Question.create(content: "Who do you admire? Why?")
Question.create(content: "What are your biggest regrets")
Question.create(content: "What makes you smile?")
Question.create(content: "What would you change about the world?")
Question.create(content: "When is the last time you did something for the first time?")
Question.create(content: "What happened to your childhood dreams?")
Question.create(content: "How have you positively changed someone else's life?")
Question.create(content: "What are you proud of?")
Question.create(content: "What do you do when you are alone?")
Question.create(content: "What makes life worth living?")
Question.create(content: "Who are you?")
Question.create(content: "What makes a real friend?")
Question.create(content: "What makes you feel alive?")
Question.create(content: "What do you spend too much time doing?")
Question.create(content: "What is a habit you want to form?")
Question.create(content: "What is most important in life?")
Question.create(content: "What makes your heart beat fast?")
Question.create(content: "What is your biggest success?")
Question.create(content: "What is your biggest faillure?")
Question.create(content: "When was the last time you spoke to a stranger?")

user = User.new(email: "tester1@test.com", password: "qwerty", age: 22, username: "tester1")
user.skip_confirmation!
user.save!

user = User.new(email: "tester2@test.com", password: "qwerty", age: 22, username: "tester2")
user.skip_confirmation!
user.save!
user = User.new(email: "tester3@test.com", password: "qwerty", age: 22, username: "tester3")
user.skip_confirmation!
user.save!
user = User.new(email: "tester4@test.com", password: "qwerty", age: 22, username: "tester4")
user.skip_confirmation!
user.save!
user = User.new(email: "tester5@test.com", password: "qwerty", age: 22, username: "tester5")
user.skip_confirmation!
user.save!
user = User.new(email: "tester6@test.com", password: "qwerty", age: 22, username: "tester6")
user.skip_confirmation!
user.save!
