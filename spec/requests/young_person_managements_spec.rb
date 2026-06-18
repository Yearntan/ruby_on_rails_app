require 'rails_helper'

RSpec.describe YoungPersonManagementsController, type: :controller do
  let(:supporter) { create(:user, :supporter) }
  let(:young_person_user) { create(:user, :young_person) }
  let(:young_person) { create(:young_person, user: young_person_user) }
  let(:young_person_management) { create(:young_person_management, supporter: supporter, young_person: young_person) }

  before do
    sign_in supporter
  end

  describe "GET #index" do
    context "when user is a supporter" do
      it "assigns young people managed by the supporter as @young_people" do
        get :index
        expect(assigns(:young_people)).to eq([young_person])
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    context "when user is not a supporter" do
      before do
        sign_in young_person_user
        get :index
      end

      it "redirects to root_path with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Access Denied')
      end
    end
  end

  describe "GET #show" do
    context "when user is a young person" do
      before do
        get :show, params: { id: young_person_user.id }
      end

      it "assigns the requested young person as @young_person" do
        expect(assigns(:young_person)).to eq(young_person)
      end

      it "assigns the answers of the young person as @answers" do
        expect(assigns(:answers)).to eq(young_person.answers)
      end

      it "renders the show template" do
        expect(response).to render_template("show")
      end
    end

    context "when user is not a young person" do
      before do
        get :show, params: { id: supporter.id }
      end

      it "redirects to root_path with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('This user does not have answers or is not accessible.')
      end
    end
  end

  describe "GET #new" do
    before do
      get :new
    end

    it "assigns active supporters as @supporters" do
      expect(assigns(:supporters)).to eq(Supporter.where(active: true))
    end

    context "with user_id parameter" do
      before do
        get :new, params: { user_id: young_person_user.id }
      end

      it "assigns the young person based on the user_id parameter" do
        expect(assigns(:young_person)).to eq(young_person)
      end

      it "assigns a new YoungPersonManagement as @young_person_management" do
        expect(assigns(:young_person_management)).to be_a_new(YoungPersonManagement)
      end
    end

    context "without user_id parameter" do
      it "sets a flash alert and renders the new template" do
        expect(flash[:alert]).to eq("No user ID provided.")
        expect(response).to render_template("new")
      end
    end

    context "with invalid user_id parameter" do
      before do
        get :new, params: { user_id: 'invalid' }
      end

      it "sets a flash alert and renders the new template" do
        expect(flash[:alert]).to eq("No young person found with the given user ID.")
        expect(response).to render_template("new")
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) {
      { supporter_id: supporter.id, young_person_id: young_person.id }
    }

    let(:invalid_attributes) {
      { supporter_id: nil, young_person_id: nil }
    }

    context "with valid parameters" do
      it "creates a new YoungPersonManagement" do
        expect {
          post :create, params: { young_person_management: valid_attributes }
        }.to change(YoungPersonManagement, :count).by(1)
      end

      it "redirects to users_path with a success notice" do
        post :create, params: { young_person_management: valid_attributes }
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('Management record created successfully.')
      end
    end

    context "with invalid parameters" do
      it "does not create a new YoungPersonManagement" do
        expect {
          post :create, params: { young_person_management: invalid_attributes }
        }.not_to change(YoungPersonManagement, :count)
      end

      it "re-renders the new template with an alert" do
        post :create, params: { young_person_management: invalid_attributes }
        expect(response).to render_template("new")
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    let(:young_person) { create(:young_person, user: young_person_user) }

    before { sign_in user }

    context "when user is authorized" do
      let(:user) { create(:user, :supporter) }

      it "sets passed_away to true" do
        delete :destroy, params: { id: young_person_user.id }
        young_person_user.reload
        expect(young_person_user.passed_away).to be true
      end
    end

    context "when user is unauthorized" do
      let(:user) { create(:user, :young_person) }

      it "does not allow the action" do
        delete :destroy, params: { id: young_person_user.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "Custom action #passed_away" do
    let(:young_person) { create(:young_person, user: young_person_user) }

    context "when young person exists" do
      before do
        patch :passed_away, params: { user_id: young_person_user.id }
      end

      it "sets passed_away to true" do
        young_person.reload
        expect(young_person.passed_away).to be true
      end

      it "redirects to young_person_managements_path with a success notice" do
        expect(response).to redirect_to(young_person_managements_path)
        expect(flash[:notice]).to eq('Young person status has changed.')
      end
    end

    context "when young person does not exist" do
      before do
        patch :passed_away, params: { user_id: 'invalid' }
      end

      it "redirects to young_person_managements_path with an alert" do
        expect(response).to redirect_to(young_person_managements_path)
        expect(flash[:alert]).to eq('Young person not found.')
      end
    end
  end

  describe "private methods" do
    describe "#set_young_person" do
      it "sets the correct young person" do
        controller.params = { id: young_person_user.id }
        controller.send(:set_young_person)
        expect(assigns(:young_person)).to eq(young_person)
      end

      it "redirects to root_path with an alert if user is not authorized" do
        allow(controller).to receive(:current_user).and_return(build(:user, role: 'unauthorized'))
        controller.params = { id: young_person_user.id }
        controller.send(:set_young_person)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Invalid user.')
      end
    end

    describe "#young_person_management_params" do
      let(:params) do
        ActionController::Parameters.new({
          young_person_management: {
            supporter_id: supporter.id,
            young_person_id: young_person.id,
            commit: 'Commit message'
          }
        })
      end

      before do
        controller.params = params
      end

      it "permits the correct parameters" do
        permitted_params = controller.send(:young_person_management_params)
        expect(permitted_params).to eq({
          "supporter_id" => supporter.id,
          "young_person_id" => young_person.id,
          "commit" => 'Commit message'
        })
      end
    end
  end
end
