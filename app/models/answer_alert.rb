# == Schema Information
#
# Table name: answer_alerts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(TRUE)
#  commit     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  answer_id  :uuid             not null
#
# Indexes
#
#  index_answer_alerts_on_answer_id  (answer_id)
#
# Foreign Keys
#
#  fk_rails_...  (answer_id => answers.id) ON DELETE => cascade
#

# The AnswerAlert class defines alert settings for answers in a database. 
# It includes features such as activation status and a commit message.
class AnswerAlert < ApplicationRecord
  # Sets up an ActiveRecord association indicating that each AnswerAlert belongs to a single Answer.
  belongs_to :answer

  # Validation: Ensures that a commit message is always present before saving.
  validates :commit, presence: true
  
  # Validation: Ensures that an associated answer_id is present before saving.
  validates :answer_id, presence: true
end
