# spec/requests/ques_categories_spec.rb
require 'rails_helper'

RSpec.describe QuesCategoriesController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  let!(:ques_category) { create(:ques_category) }
  let(:valid_attributes) { { name: 'Math', active: true } }
  let(:invalid_attributes) { { name: '', active: nil } }
  let!(:ques_category) { create(:ques_category, valid_attributes) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get ques_categories_path
      expect(response).to be_successful
    end

    it "assigns all ques_categories as @ques_categories" do
      get ques_categories_path
      expect(assigns(:ques_categories)).to eq([ques_category])
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get ques_category_path(ques_category)
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get new_ques_category_path
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get edit_ques_category_path(ques_category)
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new QuesCategory" do
        expect {
          post ques_categories_path, params: { ques_category: valid_attributes }
        }.to change(QuesCategory, :count).by(1)
      end

      it "redirects to the ques_categories list" do
        post ques_categories_path, params: { ques_category: valid_attributes }
        expect(response).to redirect_to(ques_categories_path)
        expect(flash[:notice]).to eq('Ques category was successfully created.')
      end
    end

    context "with invalid params" do
      it "does not create a new QuesCategory" do
        expect {
          post ques_categories_path, params: { ques_category: invalid_attributes }
        }.to change(QuesCategory, :count).by(0)
      end

      it "renders the new template" do
        post ques_categories_path, params: { ques_category: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: 'Science', active: false } }

      it "updates the requested ques_category" do
        put ques_category_path(ques_category), params: { ques_category: new_attributes }
        ques_category.reload
        expect(ques_category.name).to eq('Science')
        expect(ques_category.active).to be false
      end

      it "redirects to the ques_categories list" do
        put ques_category_path(ques_category), params: { ques_category: valid_attributes }
        expect(response).to redirect_to(ques_categories_path)
        expect(flash[:notice]).to eq('Question category was successfully updated.')
      end
    end

    context "with invalid params" do
      it "does not update the ques_category" do
        put ques_category_path(ques_category), params: { ques_category: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested ques_category" do
      expect {
        delete ques_category_path(ques_category)
      }.to change(QuesCategory, :count).by(-1)
    end

    it "redirects to the ques_categories list" do
      delete ques_category_path(ques_category)
      expect(response).to redirect_to(ques_categories_url)
      expect(flash[:notice]).to eq('Ques category was successfully destroyed.')
    end

    context "when destroy fails" do
      before do
        allow_any_instance_of(QuesCategory).to receive(:destroy).and_return(false)
      end

      it "redirects to the ques_categories list with an alert" do
        delete ques_category_path(ques_category)
        expect(response).to redirect_to(ques_categories_url)
        expect(flash[:alert]).to eq('Ques category could not be destroyed. Please ensure there are no dependent records.')
      end
    end
  end
  
end
