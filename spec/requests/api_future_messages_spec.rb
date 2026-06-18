# spec/controllers/api/v1/future_messages_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::FutureMessagesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:young_person_user) { create(:user, :young_person) }
  let(:young_person) { young_person_user.young_person }
  let(:loved_one) { create(:user, :loved_one) }
  let(:supporter) { create(:user, :supporter) }
  let(:future_message) { create(:future_message, young_person: young_person) }

  describe "GET #index" do
    context "when user is a young_person" do
      before do
        sign_in young_person_user
        get :index
      end

      context "when user is a loved_one" do
        before do
          sign_in loved_one
          get :index
        end
      
        it "returns the future messages associated with the loved one's bubbles" do
          expect(response).to have_http_status(:ok)
          # 检查返回的 future messages 是否与 loved_one 的 bubbles 相关联
        end
      end
      
      context "when user is a supporter" do
        before do
          sign_in supporter
          get :index, params: { user_id: young_person.user_id }
        end
      
        it "returns the future messages of the associated young person" do
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq(young_person.future_messages.as_json)
        end
      end

      it "returns the future messages of the young person" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(young_person.future_messages.as_json)
      end
    end

    context "when user is an admin" do
      before do
        sign_in admin
        get :index
      end

      it "returns all future messages" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(FutureMessage.all.as_json)
      end
    end

    context "when user is unauthorized" do
      before do
        sign_in create(:user)
        get :index
      end

      it "returns an unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET #show" do
    before do
      sign_in young_person_user
      get :show, params: { id: future_message.id }
    end

    it "returns the requested future message" do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(future_message.as_json)
    end
  end

  describe "POST #create" do
    context "with invalid params" do
      before { sign_in young_person_user }
    
      it "does not create a new future message" do
        expect {
          post :create, params: { future_message: attributes_for(:future_message, content: nil) }
        }.not_to change(FutureMessage, :count)
    
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end  

    context "when user is a young_person" do
      before { sign_in young_person_user }

      it "creates a new future message" do
        expect {
          post :create, params: { future_message: attributes_for(:future_message) }
        }.to change(FutureMessage, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "when user is unauthorized" do
      before do
        sign_in create(:user)
        post :create, params: { future_message: attributes_for(:future_message) }
      end

      it "does not create a new future message" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH/PUT #update" do
    before { sign_in young_person_user }

    context "with valid params" do
      let(:new_attributes) { { content: "Updated content" } }

      it "updates the requested future message" do
        patch :update, params: { id: future_message.id, future_message: new_attributes }
        future_message.reload
        expect(future_message.content).to eq("Updated content")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "returns unprocessable entity status" do
        patch :update, params: { id: future_message.id, future_message: { content: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in young_person_user }

    it "destroys the requested future message" do
      future_message
      expect {
        delete :destroy, params: { id: future_message.id }
      }.to change(FutureMessage, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #publish" do
    before { sign_in admin }

    context "when update fails" do
      before do
        sign_in admin
        allow_any_instance_of(FutureMessage).to receive(:update).and_return(false)
        post :publish, params: { id: future_message.id }
      end
    
      it "returns an unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end    

    context "when user is an admin" do
      it "publishes the future message" do
        post :publish, params: { id: future_message.id }
        future_message.reload
        expect(future_message.publishable).to be_truthy
        expect(response).to have_http_status(:ok)
      end
    end
  
  
    context "when admin tries to perform restricted actions" do
      before { sign_in admin }
    
      %w[edit update create destroy new].each do |action|
        it "returns unauthorized status for #{action} action" do
          get action.to_sym, params: { id: future_message.id }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end  

    context "when user is not an admin" do
      before do
        sign_in young_person_user
        post :publish, params: { id: future_message.id }
      end

      it "returns an unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
