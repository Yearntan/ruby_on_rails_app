require 'rails_helper'

RSpec.describe SupporterManagementsController, type: :controller do
  let(:user) { create(:user, :supporter) }
  let(:young_person) { create(:user, :young_person) }
  let(:supporter_management) { create(:supporter_management, supporter: user, young_person: young_person) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is a supporter" do
      it "assigns all young people associated with the supporter as @young_people" do
        get :index
        expect(assigns(:young_people)).to eq(user.young_people)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    context "when user is not a supporter" do
      it "redirects to the root path with an alert" do
        user.update(role: :admin) # Change role to non-supporter
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Access Denied')
      end
    end
  end

  describe "GET #show" do
    before do
      allow(controller).to receive(:set_supporter_management).and_return(supporter_management)
    end

    it "assigns the requested young person as @young_person" do
      get :show, params: { id: supporter_management.id }
      expect(assigns(:young_person)).to eq(supporter_management.young_person)
    end

    it "renders the show template" do
      get :show, params: { id: supporter_management.id }
      expect(response).to render_template("show")
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { young_person_id: young_person.id, status: 'active' } }
    let(:invalid_attributes) { { young_person_id: nil, status: 'active' } }

    context "with valid parameters" do
      it "creates a new SupporterManagement" do
        expect {
          post :create, params: { supporter_management: valid_attributes }
        }.to change(SupporterManagement, :count).by(1)
      end

      it "redirects to the created supporter management" do
        post :create, params: { supporter_management: valid_attributes }
        expect(response).to redirect_to(SupporterManagement.last)
        expect(flash[:notice]).to eq('Supporter management was successfully created.')
      end
    end

    context "with invalid parameters" do
      it "does not create a new SupporterManagement" do
        expect {
          post :create, params: { supporter_management: invalid_attributes }
        }.not_to change(SupporterManagement, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { supporter_management: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH/PUT #update" do
    let(:new_attributes) { { status: 'inactive' } }
    let(:invalid_attributes) { { young_person_id: nil } }

    before do
      allow(controller).to receive(:set_supporter_management).and_return(supporter_management)
    end

    context "with valid parameters" do
      it "updates the requested supporter management" do
        put :update, params: { id: supporter_management.id, supporter_management: new_attributes }
        supporter_management.reload
        expect(supporter_management.status).to eq('inactive')
      end

      it "redirects to the supporter management" do
        put :update, params: { id: supporter_management.id, supporter_management: new_attributes }
        expect(response).to redirect_to(supporter_management)
        expect(flash[:notice]).to eq('Supporter management was successfully updated.')
      end
    end

    context "with invalid parameters" do
      it "does not update the supporter management" do
        put :update, params: { id: supporter_management.id, supporter_management: invalid_attributes }
        supporter_management.reload
        expect(supporter_management.young_person_id).not_to be_nil
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: supporter_management.id, supporter_management: invalid_attributes }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(controller).to receive(:set_supporter_management).and_return(supporter_management)
    end

    it "destroys the requested supporter management" do
      expect {
        delete :destroy, params: { id: supporter_management.id }
      }.to change(SupporterManagement, :count).by(-1)
    end

    it "redirects to the supporter managements list" do
      delete :destroy, params: { id: supporter_management.id }
      expect(response).to redirect_to(supporter_managements_url)
      expect(flash[:notice]).to eq('Supporter management was successfully destroyed.')
    end
  end

  describe "private methods" do
    describe "#set_supporter_management" do
      it "sets the correct supporter management" do
        controller.send(:set_supporter_management)
        expect(assigns(:supporter_management)).to eq(supporter_management)
      end
    end

    describe "#supporter_management_params" do
      it "permits the correct parameters" do
        params = ActionController::Parameters.new({
          supporter_management: {
            young_person_id: young_person.id,
            status: 'active'
          }
        })

        permitted_params = controller.send(:supporter_management_params)
        expect(permitted_params).to eq({
          "young_person_id" => young_person.id,
          "status" => 'active'
        })
      end
    end
  end
end
