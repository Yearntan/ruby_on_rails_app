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

# The Question class models the questions stored in the database. Each question has content, a sensitivity flag
# indicating whether the content is sensitive, and belongs to a category which is optional but usually necessary.
class Question < ApplicationRecord
  # Associations

  # Questions can have multiple answers, establishing a one-to-many relationship.
  has_many :answers

  # Questions can also have multiple change requests. When a question is destroyed, its associated change requests are also deleted.
  has_many :change_requests, dependent: :destroy

  # Each question belongs to a category, although this association is optional to allow flexibility in categorization.
  belongs_to :ques_category, optional: true

  # Validations

  # Validates the presence and maximum length of the content to ensure all questions are appropriately concise and populated.
  validates :content, presence: true, length: { maximum: 255 }

  # Validates the presence of a category ID, ensuring every question is linked to a category if needed.
  validates :ques_category_id, presence: true

  # Ensures that the sensitivity attribute explicitly has either true or false, safeguarding data consistency.
  validates :sensitivity, inclusion: { in: [true, false] }

  # Private methods are used for internal class logic.

  private

  # Logs a debug message before a question is destroyed, useful for audit trails and debugging.
  def log_before_destroy
    Rails.logger.debug("Before destroy callback for Question with id: #{id}")
  end
end
