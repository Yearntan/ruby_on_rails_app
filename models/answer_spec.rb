# == Schema Information
#
# Table name: answers
#
#  id          :uuid             not null, primary key
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :uuid             not null
#  user_id     :uuid
#
# Indexes
#
#  index_answers_on_question_id              (question_id)
#  index_answers_on_question_id_and_user_id  (question_id,user_id) UNIQUE
#  index_answers_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (user_id => young_people.user_id)
#
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Answer, type: :model do
  # Describe associations of the Answer model
  describe 'associations' do
    it { is_expected.to belong_to(:question) }   # Expect Answer to belong to a Question
    it { is_expected.to belong_to(:user) }       # Expect Answer to belong to a User
    it { is_expected.to have_many(:answer_alerts) }  # Expect Answer to have many AnswerAlerts
    it { is_expected.to have_many_attached(:media) }  # Expect Answer to have many attached media files
    it { is_expected.to have_and_belong_to_many(:bubbles) }  # Expect Answer to have and belong to many Bubbles
  end

  # Describe the '#has_active_alert?' method of the Answer model
  describe '#has_active_alert?' do
    let(:answer) { create(:answer) }  # Create an answer for testing

    # Context for when there are active alerts
    context 'when there are active alerts' do
      before { create(:answer_alert, answer: answer, active: true) }  # Create an active alert for the answer

      it 'returns true' do
        expect(answer.has_active_alert?).to be true  # Expect the method to return true
      end
    end

    # Context for when there are no active alerts
    context 'when there are no active alerts' do
      it 'returns false' do
        expect(answer.has_active_alert?).to be false  # Expect the method to return false
      end
    end
  end
end

