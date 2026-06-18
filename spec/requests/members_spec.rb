require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  let(:user) { create(:user) }
  let(:young_person) { create(:young_person, user: user) }
  let(:member) { create(:invite, young_person: young_person) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is logged in" do
      it "assigns all members as @members" do
        get :index
        expect(assigns(:members)).to eq([member])
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    context "when user has no associated young person" do
      let(:user_without_yp) { create(:user) }

      before do
        sign_in user_without_yp
        get :index
      end

      it "redirects to the login page" do
        expect(response).to redirect_to(login_path)
      end
    end

    context "when user is not logged in" do
      before do
        sign_out user
        get :index
      end

      it "redirects to the login page" do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested member as @member" do
      get :show, params: { id: member.id }
      expect(assigns(:member)).to eq(member)
    end

    it "renders the show template" do
      get :show, params: { id: member.id }
      expect(response).to render_template("show")
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) {
        { name: 'John Doe', email: 'john@example.com', phone: '123-456-7890', role: 'friend' }
      }

      it "creates a new Member" do
        expect {
          post :create, params: { member: valid_attributes }
        }.to change(Invite, :count).by(1)
      end

      it "redirects to the created member with a success notice" do
        post :create, params: { member: valid_attributes }
        expect(response).to redirect_to(member_path(assigns(:member)))
        expect(flash[:notice]).to eq('Member was successfully created.')
      end
    end

    context "with missing params" do
      let(:missing_params) {
        { name: 'John Doe', email: '', phone: '123-456-7890', role: 'friend' }
      }

      it "does not create a new Member" do
        expect {
          post :create, params: { member: missing_params }
        }.not_to change(Invite, :count)
      end

      it "renders the new template with error messages" do
        post :create, params: { member: missing_params }
        expect(response).to render_template("new")
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) {
        { name: '', email: '', phone: '', role: '' }
      }

      it "does not create a new Member" do
        expect {
          post :create, params: { member: invalid_attributes }
        }.not_to change(Invite, :count)
      end

      it "renders the new template with error messages" do
        post :create, params: { member: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH/PUT #update" do
    let(:new_attributes) {
      { name: 'Jane Doe', email: 'jane@example.com', phone: '987-654-3210', role: 'family' }
    }

    context "with valid params" do
      it "updates the requested member" do
        put :update, params: { id: member.id, member: new_attributes }
        member.reload
        expect(member.name).to eq('Jane Doe')
        expect(member.email).to eq('jane@example.com')
        expect(member.phone).to eq('987-654-3210')
        expect(member.role).to eq('family')
      end

      it "redirects to the member with a success notice" do
        put :update, params: { id: member.id, member: new_attributes }
        expect(response).to redirect_to(member_path(member))
        expect(flash[:notice]).to eq('Member was successfully updated.')
      end
    end

    context "with invalid params" do
      it "does not update the member" do
        put :update, params: { id: member.id, member: { name: '' } }
        member.reload
        expect(member.name).not_to eq('')
      end

      it "renders the edit template with error messages" do
        put :update, params: { id: member.id, member: { name: '' } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do

    context "when member deletion fails" do
      before do
        allow_any_instance_of(Invite).to receive(:destroy).and_return(false)
      end

      it "does not delete the member" do
        expect {
          delete :destroy, params: { id: member.id }
        }.not_to change(Invite, :count)
      end

      it "redirects to the members index page with an error notice" do
        delete :destroy, params: { id: member.id }
        expect(response).to redirect_to(members_url)
        expect(flash[:alert]).to eq('Failed to delete member.')
      end
    end

    it "destroys the requested member" do
      member = create(:invite, young_person: young_person)
      expect {
        delete :destroy, params: { id: member.id }
      }.to change(Invite, :count).by(-1)
    end

    it "redirects to the members list with a success notice" do
      delete :destroy, params: { id: member.id }
      expect(response).to redirect_to(members_url)
      expect(flash[:notice]).to eq('Member was successfully destroyed.')
    end
  end

  describe "private methods" do
    describe "#member_params" do
      let(:params) do
        ActionController::Parameters.new({
          member: {
            name: 'John Doe',
            email: 'john@example.com',
            phone: '123-456-7890',
            role: 'friend'
          }
        })
      end

      before do
        controller.params = params
      end

      it "permits the correct parameters" do
        permitted_params = controller.send(:member_params)
        expect(permitted_params).to eq({
          "name" => 'John Doe',
          "email" => 'john@example.com',
          "phone" => '123-456-7890',
          "role" => 'friend'
        })
      end
    end
  end
end
