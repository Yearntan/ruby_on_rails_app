# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
BubbleInvite.destroy_all
BubbleMember.destroy_all
AnswersBubble.destroy_all
FutureMessagesBubble.destroy_all
Bubble.destroy_all
Answer.destroy_all
EmotionalSupport.destroy_all
YoungPersonManagement.destroy_all
Supporter.destroy_all
YoungPerson.destroy_all
User.destroy_all
Question.destroy_all
QuesCategory.destroy_all
Question.destroy_all


categories = [
  { name: 'My identity', active: true },
  { name: 'My top memories so far', active: true },
  { name: 'Remember me', active: true },
  { name: 'My bucket list', active: true },
  { name: 'Making life better', active: true },
  { name: 'My future messages', active: true },
  { name: 'Final wishes', active: true }
]

# Create or update categories
categories.each do |category_attrs|
  QuesCategory.find_or_create_by!(name: category_attrs[:name]) do |category|
    category.active = category_attrs[:active]
  end
end

questions_data = [
  { content: "Tell me a little about you ?", ques_category_id: QuesCategory.find_by(name: 'My identity').id, sensitivity: false },
  { content: "What are your most memorable moments ?", ques_category_id: QuesCategory.find_by(name: 'My top memories so far').id, sensitivity: false },
  { content: "How do you think you will be remembered?", ques_category_id: QuesCategory.find_by(name: 'Remember me').id, sensitivity: false },
  { content: "What has challenged you?", ques_category_id: QuesCategory.find_by(name: 'Remember me').id, sensitivity: false },
  { content: "What/who has made you happy in your life?", ques_category_id: QuesCategory.find_by(name: 'Remember me').id, sensitivity: false },
  { content: "Are there things/activities you would like to do?", ques_category_id: QuesCategory.find_by(name: 'My bucket list').id, sensitivity: false },
  { content: "Is there anything you would like to share with others who may have your condition/a life-limiting condition?", ques_category_id: QuesCategory.find_by(name: 'Making life better').id, sensitivity: false },
  { content: "Is there anything you want to say or repeat to the people you care about?", ques_category_id: QuesCategory.find_by(name: 'My future messages').id, sensitivity: false },
  { content: "Do you have any specific hopes or wishes for the people close to you?", ques_category_id: QuesCategory.find_by(name: 'My future messages').id, sensitivity: false },
  { content: "Do you have any advice that you would like to pass along to your friends and family?", ques_category_id: QuesCategory.find_by(name: 'My future messages').id, sensitivity: false },
  { content: "Are there any words or instructions you would like to offer your friends and family to help prepare them for life without you?", ques_category_id: QuesCategory.find_by(name: 'My future messages').id, sensitivity: false },
  { content: "What are your final needs & wishes?", ques_category_id: QuesCategory.find_by(name: 'Final wishes').id, sensitivity: true },
  { content: "Do you have any after death/funeral wishes?", ques_category_id: QuesCategory.find_by(name: 'Final wishes').id, sensitivity: true }
]

# Create or update questions
questions_data.each do |q_data|
  Question.find_or_create_by!(content: q_data[:content]) do |question|
    question.ques_category_id = q_data[:ques_category_id]
    question.sensitivity = q_data[:sensitivity]
  end
end


puts 'Seed data created for young_person_managements and associated records!'

# Check if questions exist or create some
if Question.count.zero?
  5.times do |i|
    Question.create!(content: "What is the example question #{i + 1}?", sensitivity: false, ques_category_id: 1, change: false, active: true)
  end
end

# Fetch some question IDs
question_ids = Question.pluck(:id)

# Create ChangeRequests
5.times do |i|
  ChangeRequest.create!(
    content: "Suggested change #{i + 1} for clarity.",
    status: [true, false].sample,  # Randomly choose true or false
    question_id: question_ids.sample  # Randomly assign a question from the available ones
  )
end

puts 'Seed data created for ChangeRequests!'

u1 = User.create!(
  name: "April",
  email: "yperson1@test.com",
  password: "person",
  password_confirmation: "person",
  pronouns: "He/Him",
  status: 1,
  role: :young_person,
  bypass_invite_validation: true
)



u2 = User.create!(
  name: "Zoë",
  email: "yperson2@test.com",
  password: "person",
  password_confirmation: "person",
  pronouns: "She/Her",
  status: 1,
  role: :young_person,
  bypass_invite_validation: true
)


u3 = User.create!(
  name: "supporter1",
  email: "supporter1@test.com",
  password: "supporter",
  password_confirmation: "supporter",
  pronouns: "She/Her",
  status: 4,
  role: :supporter,
  bypass_invite_validation: true
)

u4 = User.create!(
  name: "friend1",
  email: "friend1@test.com",
  password: "friend",
  password_confirmation: "friend",
  pronouns: "They/Them",
  status: 2,
  role: :loved_one,
  bypass_invite_validation: true
)

u5 = User.create!(
  name: "friend2",
  email: "friend2@test.com",
  password: "friend",
  password_confirmation: "friend",
  pronouns: "They/Them",
  status: 2,
  role: :loved_one,
  bypass_invite_validation: true
)

u6 = User.create!(
  name: "friend3",
  email: "friend3@test.com",
  password: "friend",
  password_confirmation: "friend",
  pronouns: "They/Them",
  status: 2,
  role: :loved_one,
  bypass_invite_validation: true
)

u7 = User.create!(
  name: "friend4",
  email: "friend4@test.com",
  password: "friend",
  password_confirmation: "friend",
  pronouns: "They/Them",
  status: 2,
  role: :loved_one,
  bypass_invite_validation: true
)

u8 = User.create!(
  name: "friend5",
  email: "friend5@test.com",
  password: "friend",
  password_confirmation: "friend",
  pronouns: "They/Them",
  status: 2,
  role: :loved_one,
  bypass_invite_validation: true
)

u9 = User.create!(
  name: "friend6",
  email: "friend6@test.com",
  password: "friend",
  password_confirmation: "friend",
  pronouns: "They/Them",
  status: 2,
  role: :loved_one,
  bypass_invite_validation: true
)

u10 = User.create!(
  name: "friend7",
  email: "friend7@test.com",
  password: "friend",
  password_confirmation: "friend",
  pronouns: "They/Them",
  status: 2,
  role: :loved_one,
  bypass_invite_validation: true
)

u11 = User.create!(
  name: "admin1",
  email: "admin@admin.com",
  password: "admin1",
  password_confirmation: "admin1",
  pronouns: "admin/admin",
  status: 2,
  role: :admin,
  bypass_invite_validation: true
)

u12 = User.create!(
  name: "supporter2",
  email: "supporter2@test.com",
  password: "supporter",
  password_confirmation: "supporter",
  pronouns: "She/Her",
  status: 4,
  role: :supporter,
  bypass_invite_validation: true
)
u13 = User.create!(
  name: "Joey",
  email: "yperson3@test.com",
  password: "person",
  password_confirmation: "person",
  pronouns: "He/Him",
  status: 1,
  role: :young_person,
  bypass_invite_validation: true
)
p1 = YoungPerson.create!(user: u1, passed_away: false)
p2 = YoungPerson.create!(user: u2, passed_away: false)
p3 = YoungPerson.create!(user: u13, passed_away: false)
s1 = Supporter.create!(user:u3)
s2 = Supporter.create!(user: u12)
m1 = BubbleMember.create!(user: u4)
m2 = BubbleMember.create!(user: u5)
m3 = BubbleMember.create!(user: u6)
m4 = BubbleMember.create!(user: u7)
m5 = BubbleMember.create!(user: u8)

b1 = Bubble.create!(
  holder: p1,
  name: "Friends",
  content: "My high school friends"
)

YoungPersonManagement.create!(supporter_id: s1.user_id, young_person_id: p1.user_id)
YoungPersonManagement.create!(supporter_id: s1.user_id, young_person_id: p2.user_id)
YoungPersonManagement.create!(supporter_id: s2.user_id, young_person_id: p3.user_id)


v1 = p1.invites.create!(email: "friend1@test.com", name:"Emma")
v2 = p1.invites.create!(email: "friend2@test.com", name:"Charlie")
v3 = p1.invites.create!(email: "friend3@test.com", name:"Fiona")

b1.members << v1
b1.members << v2
b1.members << v3
v1.bubble_member = m1
v2.bubble_member = m2
v3.bubble_member = m3
v1.save
v2.save
v3.save

b2 = Bubble.create!(
  holder: p1,
  name: "Team",
  content: "My sports team"
)

v4 = p1.invites.create!(email: "friend4@test.com", name:"Crow")
v5 = p1.invites.create!(email: "friend5@test.com", name:"Brian")

b2.members << v4
b2.members << v5
b2.members << p1.invites.create!(email: "friend6@test.com", name:"Cortez")

v4.bubble_member = m4
v5.bubble_member = m5
v4.save
v5.save

# b2.members << m3
# b2.members << m4

b3 = Bubble.create!(
  holder: p1,
  name: "Family",
  content: "My siblings"
)

b3.members << p1.invites.create!(email: "yperson2@test.com", name:"Zoë")
b3.members << p1.invites.create!(email: "friend8@test.com", name:"Kian")
b3.members << p1.invites.create!(email: "friend9@test.com", name:"Benrime")

b4 = Bubble.create!(
  holder: p2,
  name: "Friends",
  content: "My university friends"
)

b4.members << p2.invites.create!(email: "friend10@test.com", name:"Reza")
b4.members << p2.invites.create!(email: "friend11@test.com", name:"Olivia")
b4.members << p2.invites.create!(email: "friend12@test.com", name:"Damien")


b5 = Bubble.create!(
  holder: p2,
  name: "Family",
  content: "My parents"
)

b5.members << p2.invites.create!(email: "friend13@test.com", name:"Faith")
b5.members << p2.invites.create!(email: "friend14@test.com", name:"Dad")

b6 = Bubble.create!(
  holder: p2,
  name: "Marcuria Folks",
  content: "friends"
)

b6.members << p2.invites.create!(email: "yperson1@test.com", name:"April")

# b3.members << m2
# b3.members << m5
