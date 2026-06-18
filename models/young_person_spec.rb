# == Schema Information
#
# Table name: young_people
#
#  id          :bigint           not null, primary key
#  passed_away :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_young_people_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

# Require the rails helper file which includes RSpec configuration and some helper methods
require 'rails_helper'

# Start describing the tests for YoungPerson model
RSpec.describe YoungPerson, type: :model do
  # Create some test data using FactoryBot
  let!(:user) { FactoryBot.create(:user, :young_person) } # Create a user with the role of young_person
  let!(:young_person_1) { FactoryBot.create(:young_person, user: user) } # Create a young_person associated with the user
  let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)} # Create a friends_bubble associated with young_person_1
  let!(:user_2) { FactoryBot.create(:user, :loved_one) } # Create a user with the role of loved_one
  let!(:bubble_member_1) { FactoryBot.create(:bubble_member, user: user_2) } # Create a bubble_member associated with user_2

  # Test the #holder method
  describe "#holder" do
    it "links to a young person object" do
      # Verify if the user of young_person_1 is the expected user
      expect(young_person_1.user).to eq user
    end
  end

  # Test the #members method
  describe "#members" do
    it "links to a bubble member object" do
      # Verify if the bubbles of young_person_1 include the expected bubble
      expect(young_person_1.bubbles).to include bubble
    end
  end

  # Test the #user_id method
  describe "#user_id" do
    it "provides user_id" do
      # Verify if the user_id of young_person_1 is the expected user.id
      expect(young_person_1.user_id).to eq user.id
    end
  end
end