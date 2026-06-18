# == Schema Information
#
# Table name: future_message_alerts
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE)
#  commit            :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  future_message_id :uuid             not null
#
# Indexes
#
#  index_future_message_alerts_on_future_message_id  (future_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (future_message_id => future_messages.id)
#
require 'rails_helper'

RSpec.describe FutureMessageAlert, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
