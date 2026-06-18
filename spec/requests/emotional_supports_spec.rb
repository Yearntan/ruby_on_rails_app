require 'rails_helper'

RSpec.describe EmotionalSupportsController, type: :controller do
  let(:user) { create(:user) }
  let(:emotional_support) { create(:emotional_support, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all emotional_supports as @emotional_supports" do
      get :index
      expect(assigns(:emotional_supports)).to eq([emotional_support])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #new" do
    it "assigns a new emotional_support as @emotional_support" do
      get :new
      expect(assigns(:emotional_support)).to be_a_new(EmotionalSupport)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) {
        { content: 'I need support' }
      }

      it "creates a new EmotionalSupport" do
        expect {
          post :create, params: { emotional_support: valid_attributes }
        }.to change(EmotionalSupport, :count).by(1)
      end

      it "redirects to the questions_path with a success notice" do
        post :create, params: { emotional_support: valid_attributes }
        expect(response).to redirect_to(questions_path)
        expect(flash[:notice]).to eq('Support request was successfully created.')
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) {
        { content: '' }
      }

      it "does not create a new EmotionalSupport" do
        expect {
          post :create, params: { emotional_support: invalid_attributes }
        }.not_to change(EmotionalSupport, :count)
      end

      it "renders the new template with errors" do
        post :create, params: { emotional_support: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested emotional_support" do
      emotional_support = create(:emotional_support, user: user)
      expect {
        delete :destroy, params: { id: emotional_support.id }
      }.to change(EmotionalSupport, :count).by(-1)
    end

    it "redirects to the requests_url with a success notice" do
      delete :destroy, params: { id: emotional_support.id }
      expect(response).to redirect_to(requests_url)
      expect(flash[:notice]).to eq('Request was successfully completed.')
    end
  end

  describe "PATCH #complete" do
    context "when update is successful" do
      it "marks the emotional_support as completed" do
        patch :complete, params: { id: emotional_support.id }
        emotional_support.reload
        expect(emotional_support.status).to be true
      end

      it "redirects to the emotional_supports_path with a success notice" do
        patch :complete, params: { id: emotional_support.id }
        expect(response).to redirect_to(emotional_supports_path)
        expect(flash[:notice]).to eq('Support request was successfully completed.')
      end
    end

    context "when update fails" do
      before do
        allow_any_instance_of(EmotionalSupport).to receive(:update).and_return(false)
      end

      it "does not mark the emotional_support as completed" do
        patch :complete, params: { id: emotional_support.id }
        emotional_support.reload
        expect(emotional_support.status).not_to be true
      end

      it "redirects to the emotional_supports_path with an error notice" do
        patch :complete, params: { id: emotional_support.id }
        expect(response).to redirect_to(emotional_supports_path)
        expect(flash[:notice]).to eq('Support request could not be completed.')
      end
    end
  end

  describe "private methods" do
    describe "#emotional_support_params" do
      let(:params) do
        ActionController::Parameters.new({
          emotional_support: {
            content: 'I need support'
          }
        })
      end

      before do
        controller.params = params
      end

      it "permits the correct parameters" do
        permitted_params = controller.send(:emotional_support_params)
        expect(permitted_params).to eq({
          "content" => 'I need support'
        })
      end
    end
  end
end
