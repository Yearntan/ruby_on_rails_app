# == Schema Information
#
# Table name: young_person_managements
#
#  id              :uuid             not null, primary key
#  active          :integer          default("active")
#  commit          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  supporter_id    :uuid             not null
#  young_person_id :uuid             not null
#
# Indexes
#
#  index_yp_managements_on_id            (id)
#  index_yp_managements_on_supporter_id  (supporter_id)
#  index_yp_managements_on_yp_id         (young_person_id)
#
# Foreign Keys
#
#  fk_rails_...  (supporter_id => supporters.user_id)
#  fk_rails_...  (young_person_id => young_people.user_id)
#

# The YoungPersonManagement class facilitates the management of relationships between supporters and young people.
# It tracks the active status of these relationships and allows for additional notes or commits to be added.
class YoungPersonManagement < ApplicationRecord
  # Associations

  # Each YoungPersonManagement record is associated with one supporter, identified by supporter_id.
  belongs_to :supporter, class_name: 'User'

  # Each YoungPersonManagement record is associated with one young person, identified by young_person_id.
  belongs_to :young_person, class_name: 'User'

  # Validations

  # Validates the presence of the supporter_id attribute to ensure each record has a supporter.
  validates :supporter_id, presence: true

  # Enum for defining the active status of the relationship between a supporter and a young person.
  # The enum field 'active' can take two values: 'active' (1) or 'inactive' (0).
  enum active: { active: 1, inactive: 0 }
end
