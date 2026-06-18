# == Schema Information
#
# Table name: users
#
#  id                       :uuid             not null, primary key
#  bypass_invite_validation :boolean
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string
#  email                    :string
#  encrypted_password       :string           default(""), not null
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string
#  name                     :string
#  password                 :string
#  pronouns                 :string
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  role                     :integer
#  sign_in_count            :integer          default(0), not null
#  status                   :integer
#  token                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_users_on_id                    (id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

# The User class manages all aspects of user accounts in the system, including authentication,
# role assignment, and personal details. It leverages Devise for core functionalities like 
# database authentication, registration, and password recovery.
class User < ApplicationRecord
  # Devise setup for user authentication. Includes modules for database authentication,
  # registration, password recovery, and session tracking.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Enum for defining user roles within the system, making role management straightforward and integrated.
  enum role: { young_person: 0, loved_one: 1, supporter: 2, admin: 3 }

  # Associations
  # Each user role has specific relationships defined:
  # - YoungPerson and BubbleMember are connected via one-to-one relationships,
  # - Supporters manage YoungPeople, and vice versa, through a many-to-many relationship managed by YoungPersonManagement.
  has_one :young_person
  has_one :bubble_member
  has_many :supporter_managements, foreign_key: "supporter_id", class_name: "YoungPersonManagement"
  has_many :young_people, through: :supporter_managements, source: :young_person
  has_many :young_person_managements, foreign_key: "young_person_id", class_name: "YoungPersonManagement"
  has_many :supporters, through: :young_person_managements, source: :supporter
  has_many :answers
  has_many :emotional_supports
  has_many :invites  

  # Validations
  # Email is validated for presence and uniqueness, ensuring no duplicate records in the system.
  # Custom validations for invite codes based on creation conditions and bypass flags.
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :token, presence: true, unless: :bypass_invite_validation, on: :create
  validate :valid_invite_code, unless: :bypass_invite_validation, on: :create

  # Callbacks for setting and adjusting user data.
  before_save :downcase_email
  before_validation :assign_role_from_invite, on: :create

  # Methods
  # Standard method for converting email to lowercase to prevent case-sensitive login issues.
  def downcase_email
    self.email = email.downcase
  end

  # Method to determine if a password is required based on the user's current authentication state.
  def password_required?
    password.present? || password_confirmation.present? || encrypted_password.blank?
  end

  # Method for assigning user roles based on the provided invite token.
  # Roles are set during user creation based on valid, non-expired, and unused invite tokens.
  def assign_role_from_invite
    invite = Invite.find_by(token: token)
    self.role = invite.role if invite && invite.expiration_date > Time.current && !invite.used
  end

  private

  # Validation method to check the validity of the invite code.
  # It checks whether the invite token is valid, not expired, and not previously used.
  def valid_invite_code
    return if bypass_invite_validation
  
    invite = Invite.find_by(token: token)
    if invite.nil? || invite.expiration_date < Time.current || invite.used
      errors.add(:token, 'is invalid, expired, or has already been used')
    end
  end
end
