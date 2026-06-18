# == Schema Information
#
# Table name: questions
#
#  id               :uuid             not null, primary key
#  active           :boolean          default(TRUE)
#  change           :boolean          default(FALSE)
#  content          :text
#  sensitivity      :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  ques_category_id :bigint
#
# Foreign Keys
#
#  fk_rails_...  (ques_category_id => ques_categories.id)
#
require 'rails_helper'
RSpec.describe Question, type: :model do
  # Require rails_helper for loading Rails environment
  require 'rails_helper'

  # Test associations
  describe 'associations' do
    # Expect Question to belong to QuesCategory, association optional
    it { is_expected.to belong_to(:ques_category).optional }
    # Expect Question to have many answers with dependency on destroy
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    # Expect Question to have many change_requests with dependency on destroy
    it { is_expected.to have_many(:change_requests).dependent(:destroy) }
  end

  # Test validations
  describe 'validations' do
    # Expect Question to validate presence of content
    it { is_expected.to validate_presence_of(:content) }
    # Expect Question to validate presence of ques_category_id
    it { is_expected.to validate_presence_of(:ques_category_id) }
  end

  # Context for testing with valid attributes
  context 'with valid attributes' do
    it 'is valid' do
      question = build(:question)
      expect(question).to be_valid
    end
  end

  # Context for testing with invalid attributes
  context 'with invalid attributes' do
    # Test for invalidity without content
    it 'is not valid without content' do
      question = build(:question, content: nil)
      expect(question).not_to be_valid
    end

    # Test for invalidity without ques_category_id
    it 'is not valid without a ques_category_id' do
      question = build(:question, ques_category_id: nil)
      expect(question).not_to be_valid
    end
  end

  # Test the '#log_before_destroy' method
  describe '#log_before_destroy' do
    it 'logs information before destruction' do
      question = create(:question)
      allow(Rails.logger).to receive(:debug)  # Allow all debug messages

      # Expect the logger to receive debug message with specific content
      expect(Rails.logger).to receive(:debug).with("Before destroy callback for Question with id: #{question.id}")
      question.run_callbacks(:destroy)  # Trigger the before_destroy callback
    end
  end
end
