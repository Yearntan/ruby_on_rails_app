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

# The ChangeRequest class is used to store requests for changes or updates to existing questions.
# Each request includes content detailing the change, a status to track approval, and a link to the associated question.
class ChangeRequest < ApplicationRecord
    # Sets the database table name explicitly. Useful in cases where the table name does not follow Rails' default naming convention.
    self.table_name = "change_request"

    # Validations

    # Ensures that content is present before saving. Provides a custom error message if the content field is left blank.
    validates :content, presence: { message: "Content cannot be blank"}

    # Associations

    # Links each change request to a specific question, establishing a many-to-one relationship.
    # A change request cannot exist without an associated question, thus making 'question' a necessary entity.
    belongs_to :question
end
