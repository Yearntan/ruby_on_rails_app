# == Schema Information
#
# Table name: supporters
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_supporters_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Supporter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
