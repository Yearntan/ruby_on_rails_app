# == Schema Information
#
# Table name: future_message_alerts
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE)
#  commit            :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  future_message_id :uuid             not null
#
# Indexes
#
#  index_future_message_alerts_on_future_message_id  (future_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (future_message_id => future_messages.id)
#

# The FutureMessageAlert class manages alert settings for future messages.
# Each alert tracks whether it is active, includes a commit message describing the alert,
# and is associated with a specific future message.
class FutureMessageAlert < ApplicationRecord
    # Associations
  
    # Links each alert to a specific future message, ensuring that each alert is directly
    # associated with only one future message.
    belongs_to :future_message
  
    # Validations
  
    # Ensures that a commit message is always present before saving. This validation helps
    # in maintaining data integrity and provides context for each created alert.
    validates :commit, presence: true
  
    # Ensures that an associated future_message_id is present before saving. This is critical
    # for associating the alert with its respective future message correctly.
    validates :future_message_id, presence: true
  end
  