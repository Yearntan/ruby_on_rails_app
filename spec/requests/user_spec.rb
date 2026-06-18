require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:supporter) { create(:user, :supporter) }
  let(:young_person) { create(:user, :young_person) }
  let(:user) { create(:user) }
  let(:invite) { create(:invite, role: 'supporter', token: 'valid_token') }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "assigns all users as @users" do
      get :index
      expect(assigns(:users)).to eq(User.all)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #index with supporter_id" do
    let(:supporter_user) { create(:user, :supporter) }
    let(:young_person) { create(:user, :young_person) }
    let(:management) { create(:young_person_management, supporter_id: supporter_user.id, young_person: young_person, active: :active) }

    it "assigns users associated with the supporter" do
      get :index, params: { supporter_id: supporter_user.id }
      expect(assigns(:users)).to eq([young_person])
    end
  end


  describe "GET #show" do
    context "when user is a young person" do
      let(:management_active) { create(:young_person_management, young_person: young_person, active: :active) }
      let(:management_inactive) { create(:young_person_management, young_person: young_person, active: :unactive) }

      before do
        allow(controller).to receive(:set_user_message).and_return(young_person)
        get :show, params: { id: young_person.id }
      end

      it "assigns current and previous managements" do
        expect(assigns(:current_managements)).to include(management_active)
        expect(assigns(:previous_managements)).to include(management_inactive)
      end

      it "assigns current and previous supporters" do
        expect(assigns(:current_supporters)).to be_present
        expect(assigns(:previous_supporters)).to be_present
      end

      it "renders the show template" do
        get :show, params: { id: young_person.id }
        expect(response).to render_template("show")
      end
    end

    context "when user is not a young person" do
      before do
        allow(controller).to receive(:set_user_message).and_return(user)
        get :show, params: { id: user.id }
      end

      it "assigns empty arrays to current and previous supporters" do
        expect(assigns(:current_supporters)).to be_empty
        expect(assigns(:previous_supporters)).to be_empty
      end

      it "renders the show template" do
        expect(response).to render_template("show")
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested user as @user" do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it "renders the edit template" do
      get :edit, params: { id: user.id }
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do


    context "with missing required parameters" do
      it "does not create a new user and re-renders new template" do
        expect {
          post :create, params: { user: { email: 'test@example.com' } } # missing name, password
        }.not_to change(User, :count)
        expect(response).to render_template("new")
      end
    end
  

    context "when creating a user fails after invite is used" do
      it "does not save the user or change the invite used status" do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        expect {
          post :create, params: { user: valid_attributes }
        }.not_to change(User, :count)
        expect(invite.reload.used).to be false
      end
    end

    context "when invite update fails" do
      it "rolls back user creation" do
        allow_any_instance_of(Invite).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        expect {
          post :create, params: { user: valid_attributes }
        }.to raise_error(ActiveRecord::RecordInvalid)
        expect(User.exists?(email: valid_attributes[:email])).to be false
      end
    end
    
    context "with valid invite token" do
      let(:valid_attributes) { { name: 'Test User', email: 'test@example.com', password: 'password', token: invite.token } }

      it "creates a new user" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "assigns the role from the invite" do
        post :create, params: { user: valid_attributes }
        expect(User.last.role).to eq(invite.role)
      end

      it "marks the invite as used" do
        post :create, params: { user: valid_attributes }
        expect(invite.reload.used).to be true
      end

      it "redirects to the root URL with a success notice" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to eq("User was successfully created with role #{invite.role}.")
      end
    end

    context "with invalid invite token" do
      let(:invalid_attributes) { { name: 'Test User', email: 'test@example.com', password: 'password', token: 'invalid_token' } }

      it "does not create a new user" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it "adds an error to the user" do
        post :create, params: { user: invalid_attributes }
        expect(assigns(:user).errors[:token]).to include('is invalid or has expired')
      end

      it "re-renders the 'new' template with an alert" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH/PUT #update" do
    let(:new_attributes) { { name: 'Updated Name' } }

    before do
      allow(controller).to receive(:set_user_message).and_return(user)
    end

    context "with missing required parameters" do
      it "does not create a new user and re-renders new template" do
        expect {
          post :create, params: { user: { email: 'test@example.com' } } # missing name, password
        }.not_to change(User, :count)
        expect(response).to render_template("new")
      end
    end    


    context "with attempt to update unpermitted attributes" do
      let(:unpermitted_attributes) { { role: 'admin' } }
    
      it "does not change the role of the user" do
        original_role = user.role
        put :update, params: { id: user.id, user: unpermitted_attributes }
        user.reload
        expect(user.role).to eq(original_role)
      end
    end
    

    context "with valid parameters" do
      it "updates the requested user" do
        put :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(user.name).to eq('Updated Name')
      end

      it "redirects to the user when updating another user" do
        put :update, params: { id: user.id, user: new_attributes }
        expect(response).to redirect_to(user)
        expect(flash[:notice]).to eq('User was successfully updated.')
      end

      it "redirects to the referer when updating self" do
        allow(controller).to receive(:current_user).and_return(user)
        request.env["HTTP_REFERER"] = "http://test.host/somewhere"
        put :update, params: { id: user.id, user: new_attributes }
        expect(response).to redirect_to("http://test.host/somewhere")
        expect(flash[:notice]).to eq('User was successfully updated.')
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { email: '' } }

      it "does not update the user" do
        put :update, params: { id: user.id, user: invalid_attributes }
        user.reload
        expect(user.email).not_to be_empty
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: user.id, user: invalid_attributes }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "does not have an implemented action" do
      expect {
        delete :destroy, params: { id: user.id }
      }.to raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "PATCH #make_supporter_unactive" do
    let(:supporter_user) { create(:user, :supporter) }
    let(:supporter_record) { create(:supporter, user: supporter_user) }

    it "sets the supporter to inactive" do
      patch :make_supporter_unactive, params: { id: supporter_user.id }
      expect(supporter_record.reload.active).to be false
    end

    it "redirects to the users list" do
      patch :make_supporter_unactive, params: { id: supporter_user.id }
      expect(response).to redirect_to(users_path)
    end
  end

  describe "PATCH #make_supporter_active" do
    let(:supporter_user) { create(:user, :supporter) }
    let(:supporter_record) { create(:supporter, user: supporter_user, active: false) }

    it "sets the supporter to active" do
      patch :make_supporter_active, params: { id: supporter_user.id }
      expect(supporter_record.reload.active).to be true
    end

    it "redirects to the users list" do
      patch :make_supporter_active, params: { id: supporter_user.id }
      expect(response).to redirect_to(users_path)
    end
  end

  describe "private methods" do
    describe "#set_user_message" do
      it "sets the correct user" do
        controller.params = { id: user.id }
        controller.send(:set_user_message)
        expect(assigns(:user)).to eq(user)
      end
    end

    describe "#map_supporters" do
      let(:management) { create(:young_person_management, young_person: young_person) }
      let(:supporter) { create(:supporter, user: create(:user, :supporter)) }

      it "maps supporters from management records" do
        result = controller.send(:map_supporters, [management])
        expect(result).to include([supporter, management])
      end
    end

    describe "#user_params" do
      let(:user_with_password) { create(:user, :supporter) }
      let(:params) do
        ActionController::Parameters.new({
          user: {
            name: 'Test User',
            email: 'test@example.com',
            password: 'password',
            role: 'supporter'
          }
        })
      end

      before do
        allow(controller).to receive(:set_user_message).and_return(user_with_password)
        controller.params = params
      end

      it "permits the correct parameters including password" do
        permitted_params = controller.send(:user_params)
        expect(permitted_params).to eq({
          "name" => 'Test User',
          "email" => 'test@example.com',
          "password" => 'password',
          "role" => 'supporter'
        })
      end

      it "does not include password if it's not provided" do
        params[:user].delete(:password)
        permitted_params = controller.send(:user_params)
        expect(permitted_params).not_to include("password")
      end
    end
  end
end
