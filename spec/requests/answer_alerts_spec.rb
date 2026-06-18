require 'rails_helper'

RSpec.describe AnswerAlertsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:supporter) { create(:user, :supporter) }
  let(:young_person) { create(:user, :young_person) }
  let(:answer) { create(:answer, user: young_person) }
  let(:answer_alert) { create(:answer_alert, answer: answer) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is a supporter" do
      before do
        sign_in supporter
        allow(supporter).to receive(:supporter?).and_return(true)
        create(:young_person_management, supporter: supporter, young_person: young_person)
        create(:answer, user: young_person)
        get :index
      end

      it "retrieves young people IDs associated with the current user" do
        expect(assigns(:answer_alerts)).to include(answer_alert)
      end

      it "renders the index template" do
        expect(response).to render_template("index")
      end
    end

    context "when user is not a supporter" do
      it "redirects to the root path with an alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this page.')
      end
    end
  end

  describe "GET #new" do
    context "when user is an admin" do
      before do
        sign_in admin
        get :new, params: { answer_id: answer.id }
      end

      it "assigns a new AnswerAlert to @answer_alert" do
        expect(assigns(:answer_alert)).to be_a_new(AnswerAlert)
      end

      it "assigns the correct answer to @answer" do
        expect(assigns(:answer)).to eq(answer)
      end
    end

    context "when answer_id is missing" do
      it "raises an error" do
        sign_in admin
        expect {
          get :new, params: {}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is not an admin" do
      it "redirects to the root path with an alert" do
        get :new, params: { answer_id: answer.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this page.')
      end
    end
  end

  describe "POST #create" do
    context "when user is an admin" do
      before do
        sign_in admin
      end

      context "with valid parameters" do
        let(:valid_attributes) { attributes_for(:answer_alert, answer_id: answer.id).except(:active) }

        it "creates a new AnswerAlert" do
          expect {
            post :create, params: { answer_alert: valid_attributes }
          }.to change(AnswerAlert, :count).by(1)
        end

        it "redirects to the answers path after creation" do
          post :create, params: { answer_alert: valid_attributes }
          expect(response).to redirect_to(answers_path)
          expect(flash[:notice]).to eq('Answer alert was successfully created.')
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) { attributes_for(:answer_alert, answer_id: nil).except(:active) }

        it "does not create a new AnswerAlert" do
          expect {
            post :create, params: { answer_alert: invalid_attributes }
          }.not_to change(AnswerAlert, :count)
        end

        it "re-renders the 'new' template" do
          post :create, params: { answer_alert: invalid_attributes }
          expect(response).to render_template("new")
        end
      end
    end

    context "when user is not an admin" do
      it "redirects to the root path with an alert" do
        post :create, params: { answer_alert: attributes_for(:answer_alert, answer_id: answer.id).except(:active) }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this page.')
      end
    end
  end

  describe "GET #show" do
    context "when user is a supporter" do
      before do
        sign_in supporter
        allow(supporter).to receive(:supporter?).and_return(true)
        get :show, params: { id: answer_alert.id }
      end

      it "assigns the requested AnswerAlert to @answer_alert" do
        expect(assigns(:answer_alert)).to eq(answer_alert)
      end

      it "renders the show template" do
        expect(response).to render_template("show")
      end
    end

    context "when user is not a supporter" do
      it "redirects to the root path with an alert" do
        get :show, params: { id: answer_alert.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this page.')
      end
    end
  end

  describe "GET #edit" do
    context "when user is an admin" do
      before do
        sign_in admin
        get :edit, params: { id: answer_alert.id }
      end

      it "assigns the requested AnswerAlert to @answer_alert" do
        expect(assigns(:answer_alert)).to eq(answer_alert)
      end

      it "assigns the correct answer to @answer" do
        expect(assigns(:answer)).to eq(answer_alert.answer)
      end
    end

    context "when user is not an admin" do
      it "redirects to the root path with an alert" do
        get :edit, params: { id: answer_alert.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this page.')
      end
    end
  end

  describe "PUT #update" do
    context "when user is an admin" do
      before do
        sign_in admin
      end

      context "with valid parameters" do
        it "updates the requested AnswerAlert" do
          put :update, params: { id: answer_alert.id, answer_alert: { commit: "Updated commit" } }
          answer_alert.reload
          expect(answer_alert.commit).to eq("Updated commit")
        end

        it "redirects to the AnswerAlert" do
          put :update, params: { id: answer_alert.id, answer_alert: { commit: "Updated commit" } }
          expect(response).to redirect_to(answer_alert)
          expect(flash[:notice]).to eq('Answer alert was successfully updated.')
        end
      end

      context "with invalid parameters" do
        it "does not update the AnswerAlert" do
          put :update, params: { id: answer_alert.id, answer_alert: { commit: nil } }
          previous_commit = answer_alert.commit
          answer_alert.reload
          expect(answer_alert.commit).to eq(previous_commit)
        end

        it "re-renders the 'edit' template" do
          put :update, params: { id: answer_alert.id, answer_alert: { commit: nil } }
          expect(response).to render_template("edit")
        end
      end
    end

    context "when user is not an admin" do
      it "redirects to the root path with an alert" do
        put :update, params: { id: answer_alert.id, answer_alert: { commit: "Updated commit" } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this page.')
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is a supporter" do
      before do
        sign_in supporter
        allow(supporter).to receive(:supporter?).and_return(true)
      end

      it "sets the AnswerAlert to inactive" do
        delete :destroy, params: { id: answer_alert.id }
        answer_alert.reload
        expect(answer_alert.active).to be false
      end

      it "redirects to the AnswerAlerts list" do
        delete :destroy, params: { id: answer_alert.id }
        expect(response).to redirect_to(answer_alerts_url)
        expect(flash[:notice]).to eq('Answer alert was successfully deactivated.')
      end

      it "renders index with notice on failure to deactivate" do
        allow_any_instance_of(AnswerAlert).to receive(:update).and_return(false)
        delete :destroy, params: { id: answer_alert.id }
        expect(response).to render_template(:index)
        expect(flash[:notice]).to eq('Failed to deactivate answer alert.')
      end
    end

    context "when user is not a supporter" do
      it "redirects to the root path with an alert" do
        delete :destroy, params: { id: answer_alert.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this page.')
      end
    end
  end

  describe "PATCH #deactivate" do
    context "when user is a supporter" do
      before do
        sign_in supporter
        allow(supporter).to receive(:supporter?).and_return(true)
      end

      it "sets the AnswerAlert to inactive" do
        patch :deactivate, params: { id: answer_alert.id }
        answer_alert.reload
        expect(answer_alert.active).to be false
      end

      it "redirects to the AnswerAlerts list" do
        patch :deactivate, params: { id: answer_alert.id }
        expect(response).to redirect_to(answer_alerts_url)
        expect(flash[:notice]).to eq('Answer alert was successfully deactivated.')
      end

      it "renders index with notice on failure to deactivate" do
        allow_any_instance_of(AnswerAlert).to receive(:update).and_return(false)
        patch :deactivate, params: { id: answer_alert.id }
        expect(response).to render_template(:index)
        expect(flash[:notice]).to eq('Failed to deactivate answer alert.')
      end
    end

    context "when user is not a supporter" do
      it "redirects to the root path with an alert" do
        patch :deactivate, params: { id: answer_alert.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this page.')
      end
    end
  end
end
