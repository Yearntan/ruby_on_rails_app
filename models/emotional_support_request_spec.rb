# == Schema Information
#
# Table name: emotional_support_requests
#
#  id         :uuid             not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_emotional_support_requests_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe EmotionalSupport, type: :model do
  # Create instances for testing
  let(:user) { FactoryBot.create(:user, :young_person) }
  let(:user_2) { FactoryBot.create(:user, :supporter) }
  let(:young_person_management) { FactoryBot.create(:young_person_management, user: user, user_2: user_2) }
  let(:emotional_support) { FactoryBot.create(:emotional_support, user: user)}

  # Test connections between users
  describe "#connection" do
    it "links a supporter to a young person" do
      expect(user_2.id).to eq young_person_management.supporter_id
    end

    it "links a young person to a supporter" do
      expect(user.id).to eq young_person_management.young_person_id
    end
  end

  # Test linking support request to a young person
  describe "#request" do
    it "links a support request to a young person" do
      expect(emotional_support.user_id).to eq user.id
    end
  end
end

