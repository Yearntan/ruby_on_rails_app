require 'rails_helper'

RSpec.describe FutureMessagesController, type: :controller do
  let(:valid_attributes) {
    { content: 'Hello Future!', published_at: Time.now + 1.day }
  }

  let(:invalid_attributes) {
    { content: '', published_at: nil }
  }

  let(:user) { create(:user, :young_person) }
  let(:admin) { create(:user, :admin) }
  let(:supporter) { create(:user, :supporter) }
  let(:loved_one) { create(:user, :loved_one) }
  let(:future_message) { create(:future_message, user: user.young_person) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is a young person" do
      before do
        user.update(role: "young_person")
        get :index
      end

      it "assigns future messages as @future_messages" do
        expect(assigns(:future_messages)).to eq(user.young_person.future_messages)
      end

      it "renders the index template" do
        expect(response).to render_template("index")
      end
    end

    context "when user is an admin" do
      before do
        sign_in admin
        get :index
      end

      it "assigns all future messages as @future_messages" do
        expect(assigns(:future_messages)).to eq(FutureMessage.all)
      end
    end

    context "when user is a supporter" do
      before do
        sign_in supporter
        allow(controller).to receive(:manage_supporter_access)
        get :index
      end

      it "calls manage_supporter_access" do
        expect(controller).to have_received(:manage_supporter_access)
      end
    end

    context "when user is a loved_one" do
      before do
        sign_in loved_one
        allow(controller).to receive(:manage_loved_one_access)
        get :index
      end

      it "calls manage_loved_one_access" do
        expect(controller).to have_received(:manage_loved_one_access)
      end
    end

    context "when user is unauthorized" do
      before do
        user.update(role: "unauthorized")
        get :index
      end

      it "redirects to root_path with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to view this page.")
      end
    end
  end

  describe "GET #show" do
    before do
      allow(controller).to receive(:set_future_message).and_return(future_message)
      get :show, params: { id: future_message.id }
    end

    it "assigns the requested future message as @future_message" do
      expect(assigns(:future_message)).to eq(future_message)
    end

    it "assigns the bubbles associated with the future message as @bubbles" do
      expect(assigns(:bubbles)).to eq(future_message.bubbles)
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    before do
      get :new
    end

    it "assigns a new future message as @future_message" do
      expect(assigns(:future_message)).to be_a_new(FutureMessage)
    end

    it "assigns the bubbles associated with the young person as @bubbles" do
      expect(assigns(:bubbles)).to eq(user.young_person.try(:bubbles) || [])
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    before do
      allow(controller).to receive(:set_future_message).and_return(future_message)
      get :edit, params: { id: future_message.id }
    end

    it "assigns the requested future message as @future_message" do
      expect(assigns(:future_message)).to eq(future_message)
    end

    it "assigns the bubbles associated with the young person as @bubbles" do
      expect(assigns(:bubbles)).to eq(user.young_person.try(:bubbles) || [])
    end

    it "renders the edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new FutureMessage" do
        expect {
          post :create, params: { future_message: valid_attributes }
        }.to change(FutureMessage, :count).by(1)
      end

      it "redirects to the future_messages path with a success notice" do
        post :create, params: { future_message: valid_attributes }
        expect(response).to redirect_to(future_messages_path)
        expect(flash[:notice]).to eq('Future message was successfully created.')
      end
    end

    context "with invalid parameters" do
      it "does not create a new FutureMessage" do
        expect {
          post :create, params: { future_message: invalid_attributes }
        }.not_to change(FutureMessage, :count)
      end

      it "re-renders the new template with an alert" do
        post :create, params: { future_message: invalid_attributes }
        expect(response).to render_template("new")
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PUT #update" do
    before do
      allow(controller).to receive(:set_future_message).and_return(future_message)
    end

    context "with valid parameters" do
      let(:new_attributes) { { content: 'Updated Future Message', published_at: Time.now + 2.days } }

      it "updates the requested future_message" do
        put :update, params: { id: future_message.id, future_message: new_attributes }
        future_message.reload
        expect(future_message.content).to eq('Updated Future Message')
      end

      it "redirects to the future_message with a success notice" do
        put :update, params: { id: future_message.id, future_message: new_attributes }
        expect(response).to redirect_to(future_message)
        expect(flash[:notice]).to eq('Future message was successfully updated.')
      end
    end

    context "with invalid parameters" do
      it "does not update the future_message" do
        put :update, params: { id: future_message.id, future_message: invalid_attributes }
        future_message.reload
        expect(future_message.content).not_to eq('')
      end

      it "re-renders the edit template with an alert" do
        put :update, params: { id: future_message.id, future_message: invalid_attributes }
        expect(response).to render_template("edit")
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(controller).to receive(:set_future_message).and_return(future_message)
    end

    it "destroys the requested future_message" do
      future_message
      expect {
        delete :destroy, params: { id: future_message.id }
      }.to change(FutureMessage, :count).by(-1)
    end

    it "redirects to the future_messages list with a success notice" do
      delete :destroy, params: { id: future_message.id }
      expect(response).to redirect_to(future_messages_url)
      expect(flash[:notice]).to eq('Future message was successfully destroyed.')
    end
  end

  describe "POST #publish" do
    before do
      sign_in admin
      allow(controller).to receive(:set_future_message).and_return(future_message)
    end

    it "marks the future_message as publishable" do
      post :publish, params: { id: future_message.id }
      future_message.reload
      expect(future_message.publishable).to be true
    end

    it "redirects to the future_messages path with a success notice" do
      post :publish, params: { id: future_message.id }
      expect(response).to redirect_to(future_messages_path)
      expect(flash[:notice]).to eq('Future message was successfully published.')
    end
  end

  describe "private methods" do
    describe "#set_future_message" do
      it "sets the correct future message" do
        controller.params = { id: future_message.id }
        controller.send(:set_future_message)
        expect(assigns(:future_message)).to eq(future_message)
      end
    end

    describe "#future_message_params" do
      let(:params) do
        ActionController::Parameters.new({
          future_message: {
            content: 'Test content',
            published_at: Time.now + 1.day,
            bubble_ids: []
          }
        })
      end

      before do
        controller.params = params
      end

      it "permits the correct parameters" do
        permitted_params = controller.send(:future_message_params)
        expect(permitted_params).to eq({
          "content" => 'Test content',
          "published_at" => params[:future_message][:published_at],
          "bubble_ids" => []
        })
      end
    end

    describe "#ensure_user" do
      context "when user is authorized" do
        it "allows access for young person" do
          allow(controller).to receive(:current_user).and_return(user)
          expect(controller.send(:ensure_user)).to be_nil
        end

        it "allows access for admin" do
          allow(controller).to receive(:current_user).and_return(admin)
          expect(controller.send(:ensure_user)).to be_nil
        end

        it "allows access for supporter" do
          allow(controller).to receive(:current_user).and_return(supporter)
          expect(controller.send(:ensure_user)).to be_nil
        end

        it "allows access for loved one" do
          allow(controller).to receive(:current_user).and_return(loved_one)
          expect(controller.send(:ensure_user)).to be_nil
        end
      end

      context "when user is not authorized" do
        before do
          allow(controller).to receive(:current_user).and_return(build(:user, role: "unauthorized"))
        end

        it "redirects to root_path with an alert" do
          controller.send(:ensure_user)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end

    describe "#ensure_admin" do
      context "when user is an admin" do
        it "allows access" do
          allow(controller).to receive(:current_user).and_return(admin)
          expect(controller.send(:ensure_admin)).to be_nil
        end
      end

      context "when user is not an admin" do
        before do
          allow(controller).to receive(:current_user).and_return(user)
        end

        it "redirects to root_path with an alert" do
          controller.send(:ensure_admin)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end

    describe "#manage_loved_one_access" do
      let(:bubble_member) { create(:bubble_member, user: loved_one) }
      let(:bubble_invite) { create(:bubble_invite, bubble_member: bubble_member) }
      let(:bubble) { create(:bubble) }
      let(:future_messages_bubble) { create(:future_messages_bubble, bubble: bubble, future_message: future_message) }

      before do
        allow(controller).to receive(:current_user).and_return(loved_one)
        allow(BubbleMember).to receive(:find_by).with(user_id: loved_one.id).and_return(bubble_member)
        allow(BubbleInvite).to receive(:where).with(bubble_member_id: bubble_member.id).and_return([bubble_invite])
        allow(bubble_invite).to receive(:bubbles).and_return([bubble])
        allow(FutureMessagesBubble).to receive(:where).with(bubble_id: bubble.id).and_return([future_messages_bubble])
      end

      it "assigns future messages for loved_one role" do
        controller.send(:manage_loved_one_access)
        expect(assigns(:future_messages)).to include(future_message)
      end
    end

    describe "#manage_supporter_access" do
      let(:young_person) { create(:young_person, user: user) }

      context "when user_id is provided" do
        it "assigns future messages for the specified young person" do
          allow(YoungPerson).to receive(:find_by).with(user_id: user.id).and_return(young_person)
          controller.params = { user_id: user.id }
          controller.send(:manage_supporter_access)
          expect(assigns(:future_messages)).to eq(young_person.future_messages)
        end

        it "redirects to young_person_managements_path if no young person is found" do
          controller.params = { user_id: user.id }
          allow(YoungPerson).to receive(:find_by).with(user_id: user.id).and_return(nil)
          controller.send(:manage_supporter_access)
          expect(response).to redirect_to(young_person_managements_path)
          expect(flash[:alert]).to eq("No young person found.")
        end
      end

      context "when user_id is not provided" do
        it "redirects to young_person_managements_path with an alert" do
          controller.params = { user_id: nil }
          controller.send(:manage_supporter_access)
          expect(response).to redirect_to(young_person_managements_path)
          expect(flash[:alert]).to eq("No young person selected.")
        end
      end
    end
  end
end
