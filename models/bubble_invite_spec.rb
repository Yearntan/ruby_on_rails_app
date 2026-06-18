# == Schema Information
#
# Table name: bubble_invites
#
#  id               :bigint           not null, primary key
#  email            :string           not null
#  name             :string           not null
#  status           :integer          default("pending")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bubble_member_id :bigint
#  young_person_id  :bigint           not null
#
# Indexes
#
#  index_bubble_invites_on_bubble_member_id  (bubble_member_id)
#  index_bubble_invites_on_young_person_id   (young_person_id)
#
# Foreign Keys
#
#  fk_rails_...  (bubble_member_id => bubble_members.id)
#  fk_rails_...  (young_person_id => young_people.id)
#
require 'rails_helper'

RSpec.describe BubbleInvite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
