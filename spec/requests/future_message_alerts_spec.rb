require 'rails_helper'

RSpec.describe FutureMessageAlertsController, type: :controller do
  let(:supporter) { create(:user, :supporter) }
  let(:admin) { create(:user, :admin) }
  let(:young_person_user) { create(:user, :young_person) }
  let(:young_person) { create(:young_person, user: young_person_user) }
  let(:future_message) { create(:future_message, user: young_person) }
  let(:future_message_alert) { create(:future_message_alert, future_message: future_message) }

  before do
    sign_in supporter
  end

  describe "GET #index" do
    it "assigns all future_message_alerts as @future_message_alerts" do
      get :index
      expect(assigns(:future_message_alerts)).to eq([future_message_alert])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "assigns the requested future_message_alert as @future_message_alert" do
      get :show, params: { id: future_message_alert.id }
      expect(assigns(:future_message_alert)).to eq(future_message_alert)
    end

    it "renders the show template" do
      get :show, params: { id: future_message_alert.id }
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    before do
      sign_in admin
      get :new, params: { future_message_id: future_message.id }
    end

    it "assigns a new future_message_alert as @future_message_alert" do
      expect(assigns(:future_message_alert)).to be_a_new(FutureMessageAlert)
    end

    it "assigns the requested future_message as @future_message" do
      expect(assigns(:future_message)).to eq(future_message)
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    before { sign_in admin }

    context "with valid params" do
      let(:valid_attributes) {
        { future_message_id: future_message.id, commit: 'Commit message' }
      }

      it "creates a new FutureMessageAlert" do
        expect {
          post :create, params: { future_message_alert: valid_attributes }
        }.to change(FutureMessageAlert, :count).by(1)
      end

      it "redirects to the future_messages_path with a success notice" do
        post :create, params: { future_message_alert: valid_attributes }
        expect(response).to redirect_to(future_messages_path)
        expect(flash[:notice]).to eq('Future message alert was successfully created.')
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) {
        { future_message_id: nil, commit: '' }
      }

      it "does not create a new FutureMessageAlert" do
        expect {
          post :create, params: { future_message_alert: invalid_attributes }
        }.not_to change(FutureMessageAlert, :count)
      end

      it "renders the new template with errors" do
        post :create, params: { future_message_alert: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET #edit" do
    before do
      sign_in admin
      get :edit, params: { id: future_message_alert.id }
    end

    it "assigns the requested future_message_alert as @future_message_alert" do
      expect(assigns(:future_message_alert)).to eq(future_message_alert)
    end

    it "assigns the requested future_message as @future_message" do
      expect(assigns(:future_message)).to eq(future_message)
    end

    it "renders the edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "PATCH/PUT #update" do
    before { sign_in admin }

    context "with valid params" do
      let(:new_attributes) {
        { commit: 'Updated commit message' }
      }

      it "updates the requested future_message_alert" do
        put :update, params: { id: future_message_alert.id, future_message_alert: new_attributes }
        future_message_alert.reload
        expect(future_message_alert.commit).to eq('Updated commit message')
      end

      it "redirects to the future_message_alert with a success notice" do
        put :update, params: { id: future_message_alert.id, future_message_alert: new_attributes }
        expect(response).to redirect_to(future_message_alert)
        expect(flash[:notice]).to eq('Future message alert was successfully updated.')
      end
    end

    context "with invalid params" do
      it "does not update the future_message_alert" do
        put :update, params: { id: future_message_alert.id, future_message_alert: { commit: '' } }
        future_message_alert.reload
        expect(future_message_alert.commit).not_to eq('')
      end

      it "renders the edit template with errors" do
        put :update, params: { id: future_message_alert.id, future_message_alert: { commit: '' } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in supporter }

    it "deactivates the requested future_message_alert" do
      delete :destroy, params: { id: future_message_alert.id }
      future_message_alert.reload
      expect(future_message_alert.active).to be false
    end

    it "redirects to the future_message_alerts list with a success notice" do
      delete :destroy, params: { id: future_message_alert.id }
      expect(response).to redirect_to(future_message_alerts_url)
      expect(flash[:notice]).to eq('Future message alert was successfully deactivated.')
    end

    context "when deactivation fails" do
      before do
        allow_any_instance_of(FutureMessageAlert).to receive(:update).and_return(false)
      end

      it "renders the index template with an alert" do
        delete :destroy, params: { id: future_message_alert.id }
        expect(response).to render_template("index")
        expect(flash[:notice]).to eq('Failed to deactivate future message alert.')
      end
    end
  end

  describe "private methods" do
    describe "#set_future_message_alert" do
      it "sets the correct future_message_alert" do
        controller.params = { id: future_message_alert.id }
        controller.send(:set_future_message_alert)
        expect(assigns(:future_message_alert)).to eq(future_message_alert)
      end
    end

    describe "#future_message_alert_params" do
      let(:params) do
        ActionController::Parameters.new({
          future_message_alert: {
            future_message_id: future_message.id,
            commit: 'Commit message'
          }
        })
      end

      before do
        controller.params = params
      end

      it "permits the correct parameters" do
        permitted_params = controller.send(:future_message_alert_params)
        expect(permitted_params).to eq({
          "future_message_id" => future_message.id,
          "commit" => 'Commit message'
        })
      end
    end

    describe "#make_sure_user_is_supporter" do
      context "when user is a supporter" do
        it "allows access" do
          allow(controller).to receive(:current_user).and_return(supporter)
          expect(controller.send(:make_sure_user_is_supporter)).to be_nil
        end
      end

      context "when user is not a supporter" do
        before do
          allow(controller).to receive(:current_user).and_return(young_person_user)
        end

        it "redirects to root_path with an alert" do
          controller.send(:make_sure_user_is_supporter)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to view this page.')
        end
      end
    end

    describe "#make_sure_user_is_admin" do
      context "when user is an admin" do
        it "allows access" do
          allow(controller).to receive(:current_user).and_return(admin)
          expect(controller.send(:make_sure_user_is_admin)).to be_nil
        end
      end

      context "when user is not an admin" do
        before do
          allow(controller).to receive(:current_user).and_return(supporter)
        end

        it "redirects to root_path with an alert" do
          controller.send(:make_sure_user_is_admin)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to view this page.')
        end
      end
    end
  end
end
