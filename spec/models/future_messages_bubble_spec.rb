# == Schema Information
#
# Table name: future_messages_bubbles
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  bubble_id         :uuid             not null
#  future_message_id :uuid             not null
#
# Indexes
#
#  index_fmsg_bubbles_on_fmsg_id_and_bubble_id         (future_message_id,bubble_id) UNIQUE
#  index_future_messages_bubbles_on_bubble_id          (bubble_id)
#  index_future_messages_bubbles_on_future_message_id  (future_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (bubble_id => bubbles.id)
#  fk_rails_...  (future_message_id => future_messages.id)
#
require 'rails_helper'

RSpec.describe FutureMessagesBubble, type: :model do
  let(:future_message) { create(:future_message) }
  let(:bubble) { create(:bubble) }
  let(:future_messages_bubble) { create(:future_messages_bubble, future_message: future_message, bubble: bubble) }

  context "associations" do
    it { should belong_to(:future_message).class_name('FutureMessage').with_foreign_key('future_message_id') }
    it { should belong_to(:bubble).class_name('Bubble').with_foreign_key('bubble_id') }
  end

  context "validations" do
    it "is valid with valid attributes" do
      expect(future_messages_bubble).to be_valid
    end

    it "is not valid without a future_message" do
      future_messages_bubble.future_message = nil
      expect(future_messages_bubble).not_to be_valid
    end

    it "is not valid without a bubble" do
      future_messages_bubble.bubble = nil
      expect(future_messages_bubble).not_to be_valid
    end

    it "ensures uniqueness of future_message scoped to bubble" do
      duplicate = build(:future_messages_bubble, future_message: future_message, bubble: bubble)
      expect(duplicate).not_to be_valid
    end
  end
end
