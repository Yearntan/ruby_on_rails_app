# == Schema Information
#
# Table name: future_messages_bubbles
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  bubble_id         :uuid             not null
#  future_message_id :uuid             not null
#
# Indexes
#
#  index_fmsg_bubbles_on_fmsg_id_and_bubble_id         (future_message_id,bubble_id) UNIQUE
#  index_future_messages_bubbles_on_bubble_id          (bubble_id)
#  index_future_messages_bubbles_on_future_message_id  (future_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (bubble_id => bubbles.id)
#  fk_rails_...  (future_message_id => future_messages.id)
#

# The FutureMessagesBubble class represents the join table between FutureMessage and Bubble entities,
# facilitating a many-to-many relationship. It ensures that each future message can be associated with one or more bubbles,
# and vice versa, allowing categorization of messages into different thematic groups.
class FutureMessagesBubble < ApplicationRecord
  # Associations
  
  # Each record belongs to a FutureMessage, identified by 'future_message_id'.
  # This association links a future message to a bubble, part of categorizing messages.
  belongs_to :future_message, class_name: 'FutureMessage', foreign_key: 'future_message_id'
  
  # Each record also belongs to a Bubble, identified by 'bubble_id'.
  # This setup allows bubbles to be associated with multiple future messages.
  belongs_to :bubble, class_name: 'Bubble', foreign_key: 'bubble_id'
end
