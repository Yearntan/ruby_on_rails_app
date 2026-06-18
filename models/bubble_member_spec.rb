# == Schema Information
#
# Table name: bubble_members
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_bubble_members_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe BubbleMember, type: :model do
  # Create user and bubble instances for testing
  let(:user) { FactoryBot.create(:user, :young_person) }
  let(:young_person_1) { FactoryBot.create(:young_person, user: user) }
  let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)}
  let!(:user_2) { FactoryBot.create(:user, :loved_one) }
  let!(:member) { FactoryBot.create(:bubble_member, user: user_2) }

  # Test associations
  describe "#user" do
    it "links to a user object" do
      expect(member.user).to eq user_2
    end
  end

  describe "#bubble" do
    before do
      bubble.members << member
    end
    it "links to a bubble object" do
      expect(member.bubbles).to include bubble
    end
  end

  # Test attributes
  describe "#id" do
    it "provides id" do
      expect(member.id).to eq 3
    end
  end

  describe "#user_id" do
    it "provides user_id" do
      expect(member.user_id).to eq user_2.id
    end
  end

  describe "#name" do
    it "provides name" do
      expect(member.name).to eq nil
    end
  end

  describe "#email" do
    it "provides email" do
      expect(member.email).to eq nil
    end
  end
end
