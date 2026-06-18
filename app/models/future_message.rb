# == Schema Information
#
# Table name: future_messages
#
#  id           :uuid             not null, primary key
#  content      :text
#  publishable  :boolean          default(FALSE)
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_future_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => young_people.user_id)
#

# The FutureMessage class models messages that are intended to be published at a future date.
# Each message is linked to a young person and can be associated with various bubbles (categories or tags).
# It includes features like scheduled publishing and alert management.
class FutureMessage < ApplicationRecord
  # Associations
  
  # Each future message is associated with a specific young person, identified by 'user_id'.
  # This ensures that messages are tied to the creator's identity.
  belongs_to :young_person, foreign_key: 'user_id', primary_key: 'user_id'
  
  # Manages the relationship between messages and bubbles. Messages can belong to multiple bubbles.
  has_many :future_messages_bubbles
  has_many :bubbles, through: :future_messages_bubbles

  # Manages alerts specific to this future message. If a message is deleted, its alerts are also destroyed.
  has_many :future_message_alerts, dependent: :destroy

  # Validations
  
  # Ensures that content is always present in the message, requiring it for saving to the database.
  validates :content, presence: true

  # Ensures that a publication date is set for the message, crucial for scheduling.
  validates :published_at, presence: true

  # Methods
  
  # Checks if there are any active alerts associated with this future message.
  # Returns true if at least one active alert exists, facilitating monitoring and response.
  def has_active_alert?
    future_message_alerts.where(active: true).exists?
  end
end
