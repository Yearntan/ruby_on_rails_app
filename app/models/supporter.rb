# == Schema Information
#
# Table name: supporters
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_supporters_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

# The Supporter class represents individuals or entities within the application who provide support
# and are linked to specific users. This class facilitates managing the roles and activities
# that supporters can undertake, including sending invites.
class Supporter < ApplicationRecord
  # Associations
  
  # Each supporter is linked to exactly one user, defining the supporter's identity within the system.
  # This relationship ensures that each user ID is associated with only one supporter, as enforced by the unique index.
  belongs_to :user

  # Supporters can issue multiple invites, specifically modeled as BubbleInvites within the system.
  # This association allows supporters to manage and send invites to users to join various bubbles.
  has_many :invites, class_name: "BubbleInvite"
end
