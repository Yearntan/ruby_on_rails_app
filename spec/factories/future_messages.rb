# == Schema Information
#
# Table name: future_messages
#
#  id           :uuid             not null, primary key
#  content      :text
#  publishable  :boolean          default(FALSE)
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_future_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => young_people.user_id)
#
FactoryBot.define do
  factory :future_message do
    # Set default value of id attribute to ""
    id { "" }
    # Set default content for the future message
    content { "MyText" }
    # Set default published_at timestamp for the future message
    published_at { "2024-03-13 20:28:52" }
    # Set default value of user attribute to nil
    young_person
  end
end

