# == Schema Information
#
# Table name: invites
#
#  id              :bigint           not null, primary key
#  code            :string
#  email           :string
#  expiration_date :datetime
#  message         :text
#  role            :string
#  token           :string
#  used            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :uuid
#

# The Invite class is used to manage invitations sent to potential new users or existing users for specific roles
# within the system. Invites contain a unique token and can carry a message, specify a role, and track usage.
class Invite < ApplicationRecord
  # Associations
  
  # Each invite may be linked to a user, indicating who created or who is linked to the invite.
  # This association is optional as invites can be created without a specific user in mind.
  belongs_to :user, optional: true
  
  # Validations
  
  # Ensures the role is present and only allows specific predefined roles for consistency and security.
  validates :role, presence: true, inclusion: { in: ['admin', 'supporter', 'young_person', 'loved_one'] }
  
  # Restricts the message length to 500 characters, but allows it to be blank if no message is desired.
  validates :message, length: { maximum: 500 }, allow_blank: true
  
  # Ensures the token is unique and present, critical for the invite's integrity and functionality.
  validates :token, uniqueness: true, presence: true
  
  # Callbacks
  
  # Generates a unique token before validation on creation. This ensures that every invite has a unique identifier.
  before_validation :generate_token, on: :create
  
  # Sets the expiration date of the invite to 5 days from creation unless already set.
  # This helps in managing the validity period of the invite.
  before_create :set_expiration_date
  
  private
  
  # Private methods to be used as callbacks only within the class.
  
  # Generates a secure random hexadecimal string as a token for the invite.
  def generate_token
    self.token ||= SecureRandom.hex(10)  # Ensures token is set only if it hasn't been set already.
  end
  
  # Sets the expiration date of the invite to 5 days from the time of creation if not already set.
  def set_expiration_date
    self.expiration_date ||= 5.days.from_now
  end
end
