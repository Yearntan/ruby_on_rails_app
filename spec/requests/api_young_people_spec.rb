# spec/controllers/api/v1/young_people_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::YoungPeopleController, type: :controller do
  let(:young_person_user) { create(:user, :young_person) }
  let(:young_person) { young_person_user.young_person }
  let(:other_user) { create(:user) }

  before do
    sign_in young_person_user
  end

  describe "DELETE #destroy" do
    context "when user is authorized" do
      before do
        allow_any_instance_of(User).to receive(:can_manage?).and_return(true)
      end

      it "updates the young person's passed_away status to true" do
        delete :destroy, params: { id: young_person.id }
        young_person.reload
        expect(young_person.passed_away).to be true
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ "success" => true, "message" => 'Successfully updated the status.' })
      end

      it "returns an error when the update fails" do
        allow_any_instance_of(YoungPerson).to receive(:update).and_return(false)
        delete :destroy, params: { id: young_person.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "success" => false, "error" => 'Failed to update the status.' })
      end
    end

    context "when user is not authorized" do
      before do
        allow_any_instance_of(User).to receive(:can_manage?).and_return(false)
      end

      it "returns an unauthorized status" do
        delete :destroy, params: { id: young_person.id }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ "error" => 'Invalid user.' })
      end
    end

    context "when young person is not found" do
      it "returns an unauthorized status" do
        delete :destroy, params: { id: -1 }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ "error" => 'Invalid user.' })
      end
    end
  end
end
