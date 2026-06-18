# == Schema Information
#
# Table name: ques_categories
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'
RSpec.describe QuesCategory, type: :model do
  # Test associations
  describe 'associations' do
    # Expect QuesCategory to have many questions with dependency on destroy
    it { is_expected.to have_many(:questions).dependent(:destroy) }
  end

  # Test validations
  describe 'validations' do
    # Expect QuesCategory to validate presence of name attribute
    it { is_expected.to validate_presence_of(:name).with_message("Name cannot be blank") }
    # Expect QuesCategory to validate presence of active attribute
    it { is_expected.to validate_presence_of(:active).with_message("Please specify if the category is active") }
  end

  # Testing creation of a QuesCategory
  describe 'creating a new QuesCategory' do
    let(:category_active) { FactoryBot.create(:ques_category, active: true, name: 'Education') }
    let(:category_inactive) { FactoryBot.create(:ques_category, active: false, name: 'Recreation') }

    # Test for a valid QuesCategory instance with valid attributes
    it 'is valid with valid attributes' do
      expect(category_active).to be_valid
      expect(category_inactive).to be_valid
    end

    # Test for an invalid QuesCategory instance without a name
    it 'is not valid without a name' do
      category = FactoryBot.build(:ques_category, name: nil)
      expect(category).not_to be_valid
      expect(category.errors.messages[:name]).to include("Name cannot be blank")
    end

    # Test for an invalid QuesCategory instance without specifying active
    it 'is not valid without specifying active' do
      category = FactoryBot.build(:ques_category, active: nil)
      expect(category).not_to be_valid
      expect(category.errors.messages[:active]).to include("Please specify if the category is active")
    end
  end
end
