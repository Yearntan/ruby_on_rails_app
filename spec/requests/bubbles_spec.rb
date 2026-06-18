require 'rails_helper'

RSpec.describe BubblesController, type: :controller do
  let(:user) { create(:user) }
  let(:young_person) { create(:young_person, user: user) }
  let(:bubble) { create(:bubble, holder_id: young_person.id) }
  let(:supporter) { create(:user, role: 'supporter') }
  let(:loved_one) { create(:user, role: 'loved_one') }
  let(:member) { create(:bubble_invite) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "as a young person" do
      before { user.update(role: 'young_person') }

      it "assigns all bubbles as @bubbles for the young person" do
        get :index
        expect(assigns(:bubbles)).to eq([bubble])
      end
    end

    context "as a supporter" do
      before do
        sign_in supporter
      end

      it "redirects to supporter dashboard if no user_id is provided" do
        get :index
        expect(response).to redirect_to(supporter_dashboard_path)
      end

      it "assigns bubbles for a specific young person if user_id is provided" do
        young_person
        get :index, params: { user_id: young_person.user_id }
        expect(assigns(:bubbles)).to eq([bubble])
      end

      it "redirects if young person is not found" do
        get :index, params: { user_id: 9999 } # Non-existent user ID
        expect(response).to redirect_to(supporter_dashboard_path)
        expect(flash[:alert]).to eq("No young person found.")
      end
    end

    context "as a loved one" do
      before do
        sign_in loved_one
      end

      it "assigns bubbles for the loved one" do
        bubble_member = create(:bubble_member, user: loved_one)
        create(:bubble_invite, bubble_member: bubble_member, bubble: bubble)
        get :index
        expect(assigns(:bubbles)).to eq([bubble])
      end
    end

    context "as an unauthorized user" do
      before do
        user.update(role: 'guest')
      end

      it "redirects to the root path with an alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to view this page.")
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested bubble as @bubble" do
      get :show, params: { id: bubble.id }
      expect(assigns(:bubble)).to eq(bubble)
    end
  end

  describe "GET #new" do
    it "assigns a new bubble as @bubble" do
      get :new
      expect(assigns(:bubble)).to be_a_new(Bubble)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) {
        { name: 'New Bubble', content: 'Content for new bubble', holder_id: young_person.id }
      }

      it "creates a new Bubble" do
        expect {
          post :create, params: { bubble: valid_attributes }
        }.to change(Bubble, :count).by(1)
      end

      it "redirects to the created bubble" do
        post :create, params: { bubble: valid_attributes }
        expect(response).to redirect_to(bubbles_path)
      end
    end

    context "with invalid params" do
      it "re-renders the 'new' template" do
        post :create, params: { bubble: { name: '' } }
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested bubble as @bubble" do
      get :edit, params: { id: bubble.id }
      expect(assigns(:bubble)).to eq(bubble)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'Updated Name' }
      }

      it "updates the requested bubble" do
        put :update, params: { id: bubble.id, bubble: new_attributes }
        bubble.reload
        expect(bubble.name).to eq('Updated Name')
      end

      it "redirects to the bubble" do
        put :update, params: { id: bubble.id, bubble: new_attributes }
        expect(response).to redirect_to(bubble)
      end
    end

    context "with invalid params" do
      it "re-renders the 'edit' template" do
        put :update, params: { id: bubble.id, bubble: { name: '' } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested bubble" do
      bubble.save
      expect {
        delete :destroy, params: { id: bubble.id }
      }.to change(Bubble, :count).by(-1)
    end

    it "redirects to the bubbles list" do
      delete :destroy, params: { id: bubble.id }
      expect(response).to redirect_to(bubbles_path)
    end
  end

  describe "GET #assign" do
    before do
      sign_in young_person.user
    end

    it "assigns a member to the bubble" do
      expect {
        get :assign, params: { bubble_id: bubble.id, member_id: member.id }
      }.to change(bubble.members, :count).by(1)
      expect(response).to redirect_to(bubble_path(bubble))
      expect(flash[:notice]).to eq("Member was successfully assigned.")
    end
  end

  describe "GET #unassign" do
    before do
      sign_in young_person.user
      bubble.members << member
    end

    it "unassigns a member from the bubble" do
      expect {
        get :unassign, params: { bubble_id: bubble.id, member_id: member.id }
      }.to change(bubble.members, :count).by(-1)
      expect(response).to redirect_to(bubble_path(bubble))
      expect(flash[:notice]).to eq("Member was successfully unassigned.")
    end
  end


  
  describe "GET #index" do
    context "when user is a supporter" do
      before do
        sign_in supporter
        allow(supporter).to receive(:supporter?).and_return(true)
        young_person_management = create(:young_person_management, supporter: supporter, young_person: young_person)
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
        allow(user).to receive(:supporter?).and_return(true)
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
        allow(user).to receive(:supporter?).and_return(true)
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
