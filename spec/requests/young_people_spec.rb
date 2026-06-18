require 'rails_helper'

RSpec.describe YoungPeopleController, type: :controller do
  let(:supporter) { create(:user, :supporter) }
  let(:young_person_user) { create(:user, :young_person) }
  let(:young_person) { create(:young_person, user: young_person_user) }

  before do
    sign_in supporter
  end

  describe "DELETE #destroy" do
    context "when user is authorized" do
      before do
        allow(controller).to receive(:set_young_person).and_return(young_person)
      end

      it "sets passed_away to true" do
        delete :destroy, params: { id: young_person.id }
        young_person.reload
        expect(young_person.passed_away).to be true
      end

      it "redirects to young_people_url with a success notice" do
        delete :destroy, params: { id: young_person.id }
        expect(response).to redirect_to(young_people_url)
        expect(flash[:notice]).to eq('Successfully updated the status.')
      end
    end

    context "when user is unauthorized" do
      before do
        allow(controller).to receive(:set_young_person).and_return(nil)
      end

      it "does not allow the action" do
        delete :destroy, params: { id: young_person.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Invalid user.')
      end
    end

    context "when update fails" do
      before do
        allow(controller).to receive(:set_young_person).and_return(young_person)
        allow(young_person).to receive(:update).and_return(false)
      end

      it "redirects to young_people_url with an alert" do
        delete :destroy, params: { id: young_person.id }
        expect(response).to redirect_to(young_people_url)
        expect(flash[:alert]).to eq('Failed to update the status.')
      end
    end
  end

  describe "private methods" do
    describe "#set_young_person" do
      context "when user is authorized to manage the young person" do
        before do
          allow(controller).to receive(:current_user).and_return(supporter)
          allow(supporter).to receive(:can_manage?).and_return(true)
          controller.params = { user_id: young_person_user.id }
        end

        it "sets the correct young person" do
          controller.send(:set_young_person)
          expect(assigns(:young_person)).to eq(young_person)
        end
      end

      context "when user is not authorized to manage the young person" do
        before do
          allow(controller).to receive(:current_user).and_return(supporter)
          allow(supporter).to receive(:can_manage?).and_return(false)
          controller.params = { user_id: young_person_user.id }
        end

        it "redirects to root_path with an alert" do
          controller.send(:set_young_person)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Invalid user.')
        end
      end

      context "when young person does not exist" do
        before do
          controller.params = { user_id: 'invalid' }
        end

        it "redirects to root_path with an alert" do
          controller.send(:set_young_person)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Invalid user.')
        end
      end
    end
  end
end
