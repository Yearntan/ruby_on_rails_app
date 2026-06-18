# == Schema Information
#
# Table name: change_request
#
#  id          :uuid             not null, primary key
#  content     :text
#  status      :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :uuid             not null
#
# Indexes
#
#  index_change_request_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
require 'rails_helper'
RSpec.describe ChangeRequest, type: :model do
  # Test validations
  describe 'validations' do
    # Expect ChangeRequest to validate presence of content attribute
    it { is_expected.to validate_presence_of(:content).with_message("Content cannot be blank") }
  end

  # Test associations
  describe 'associations' do
    # Expect ChangeRequest to belong to a Question
    it { is_expected.to belong_to(:question) }
  end

  # Additional tests to check creation of valid and invalid instances
  describe 'creating a ChangeRequest' do
    let(:question) { FactoryBot.create(:question) }  # Assuming you have a factory for Question

    # Test for a valid ChangeRequest instance
    it 'is valid with valid attributes' do
      change_request = ChangeRequest.new(content: "Need more details on the topic.", question: question)
      expect(change_request).to be_valid
    end

    # Test for an invalid ChangeRequest instance without content
    it 'is not valid without content' do
      change_request = ChangeRequest.new(content: "", question: question)
      expect(change_request).not_to be_valid
      expect(change_request.errors[:content]).to include("Content cannot be blank")
    end

    # Test for an invalid ChangeRequest instance without a question
    it 'is not valid without a question' do
      change_request = ChangeRequest.new(content: "Update the explanation.")
      expect(change_request).not_to be_valid
      expect(change_request.errors[:question]).to include("must exist")
    end
  end
end
