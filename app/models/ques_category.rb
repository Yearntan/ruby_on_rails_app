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

# The QuesCategory class represents categories for grouping questions within the application.
# Each category is defined by a name and an active status, which allows for enabling or disabling categories dynamically.
class QuesCategory < ApplicationRecord
    # Associations
    
    # Establishes a one-to-many relationship with questions. When a category is deleted,
    # all associated questions are also destroyed, ensuring no orphaned records remain.
    has_many :questions, dependent: :destroy
  
    # Validations
    
    # Ensures that each category has a name before it can be saved to the database. 
    # A custom error message is provided if this validation fails.
    validates :name, presence: { message: "Name cannot be blank" }
  end
  