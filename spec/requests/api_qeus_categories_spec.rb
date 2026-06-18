require 'rails_helper'

RSpec.describe Api::V1::QuesCategoriesController, type: :controller do
  let(:valid_attributes) {
    { name: 'Science', active: true }
  }

  let(:invalid_attributes) {
    { name: '', active: false }
  }

  let(:ques_category) { create(:ques_category) }

  describe "GET #index" do
    it "returns a success response" do
      ques_category
      get :index
      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including("application/json"))
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: ques_category.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new QuesCategory" do
        expect {
          post :create, params: { ques_category: valid_attributes }
        }.to change(QuesCategory, :count).by(1)
      end

      it "renders a JSON response with the new ques_category" do
        post :create, params: { ques_category: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new ques_category" do
        post :create, params: { ques_category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'Mathematics', active: true }
      }

      it "updates the requested ques_category" do
        put :update, params: { id: ques_category.to_param, ques_category: new_attributes }
        ques_category.reload
        expect(ques_category.name).to eq('Mathematics')
      end

      it "renders a JSON response with the ques_category" do
        put :update, params: { id: ques_category.to_param, ques_category: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the ques_category" do
        put :update, params: { id: ques_category.to_param, ques_category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested ques_category" do
      ques_category
      expect {
        delete :destroy, params: { id: ques_category.to_param }
      }.to change(QuesCategory, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    context "when category has dependent records" do
      before do
        allow_any_instance_of(QuesCategory).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it "does not destroy the requested ques_category and returns a conflict response" do
        delete :destroy, params: { id: ques_category.to_param }
        expect(response).to have_http_status(:conflict)
        expect(response.body).to include('could not be destroyed')
      end
    end
  end
end
