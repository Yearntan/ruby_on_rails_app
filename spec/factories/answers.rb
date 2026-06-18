# == Schema Information
#
# Table name: answers
#
#  id          :uuid             not null, primary key
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :uuid             not null
#  user_id     :uuid
#
# Indexes
#
#  index_answers_on_question_id              (question_id)
#  index_answers_on_question_id_and_user_id  (question_id,user_id) UNIQUE
#  index_answers_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (user_id => young_people.user_id)
#
FactoryBot.define do
  factory :answer do
    # Set default content for the answer
    content { "This is an answer." }
    # Create an association between the answer and a User object
    association :user
    # Create an association between the answer and a Question object
    association :question
  end
end

