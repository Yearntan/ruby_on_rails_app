# == Schema Information
#
# Table name: emotional_supports
#
#  id         :uuid             not null, primary key
#  content    :text
#  status     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_emotional_supports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => young_people.user_id)
#

# The EmotionalSupport class manages records of emotional support interactions provided to young people.
# Each record tracks the content of the support given, its current status (active or resolved), and is linked to a specific young person.
class EmotionalSupport < ApplicationRecord
    # Associations
    
    # Establishes a relationship between the emotional support entry and a young person. This specifies that each emotional
    # support record is owned by a young person, using 'user_id' as the foreign key.
    belongs_to :young_person, foreign_key: :user_id, primary_key: :user_id
  
    # Additional attributes such as 'content', 'status', 'created_at', and 'updated_at' are implicitly managed by ActiveRecord.
  end
  