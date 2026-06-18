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

# The Answer class models the answers provided by young people to specific questions.
# It includes references to both questions and the responding user, and it supports attachments
# and associated alert functionalities.
class Answer < ApplicationRecord
  # Associations
  # Each answer is associated with a specific question.
  belongs_to :question
  
  # Each answer is associated with a specific young person. The 'user_id' is used as the foreign key.
  belongs_to :young_person, foreign_key: 'user_id', primary_key: 'user_id'
  
  # Supports multiple media attachments per answer.
  has_many_attached :media
  
  # Relationship through which answers can be linked to multiple bubbles (categories or tags).
  has_many :answers_bubbles
  has_many :bubbles, through: :answers_bubbles

  # Associations for alerts related to an answer, with a dependency that deletes alerts if the answer is deleted.
  has_many :answer_alerts, dependent: :destroy

  # Validations
  # Ensures that each combination of user and question is unique, preventing duplicate answers.
  validates :user_id, uniqueness: { scope: :question_id }
  
  # Ensures that the content field is not empty.
  validates :content, presence: true

  # Instance Methods
  # Method to check if there is any active alert associated with the answer.
  # Returns true if at least one active alert exists.
  def has_active_alert?
    answer_alerts.where(active: true).exists?
  end
end
