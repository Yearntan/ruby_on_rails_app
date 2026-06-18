# == Schema Information
#
# Table name: patient_managements
#
#  commit       :text
#  status       :integer          default("active")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  patient_id   :uuid             not null, primary key
#  supporter_id :uuid             not null, primary key
#
# Indexes
#
#  index_patient_managements_on_patient_id                   (patient_id)
#  index_patient_managements_on_supporter_id                 (supporter_id)
#  index_patient_managements_on_supporter_id_and_patient_id  (supporter_id,patient_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (patient_id => users.id)
#  fk_rails_...  (supporter_id => users.id)
#
# require 'rails_helper'

# RSpec.describe PatientManagement, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
