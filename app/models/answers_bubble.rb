# == Schema Information
#
# Table name: answers_bubbles
#
#  id        :bigint           not null, primary key
#  answer_id :uuid             not null
#  bubble_id :uuid             not null
#
# Indexes
#
#  index_answers_bubbles_on_answer_id_and_bubble_id  (answer_id,bubble_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (answer_id => answers.id)
#  fk_rails_...  (bubble_id => bubbles.id)
#

# The AnswersBubble class represents the join table for a many-to-many relationship
# between Answers and Bubbles. It facilitates the categorization or tagging of answers
# with different 'bubbles' (categories or tags).
class AnswersBubble < ApplicationRecord
  # Associations
  # Each AnswersBubble record belongs to an Answer, linking it to the specific answer instance.
  belongs_to :answer
  
  # Each AnswersBubble record also belongs to a Bubble, linking it to the specific bubble instance.
  belongs_to :bubble
end
