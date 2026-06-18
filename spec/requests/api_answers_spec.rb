require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:young_person) { create(:young_person, user: user) }
  let(:answer) { create(:answer, young_person: young_person, user_id: user.id) }

  before do
    sign_in user  # if using Devise or similar, setup this helper for controller specs
  end

  describe "GET #index" do
    context "as admin" do
        it "returns all answers" do
        user.update(role: 'admin')
        create(:answer, user_id: user.id)  # Explicitly create an answer here
        puts Answer.all.inspect  # Debugging output to check records
        get :index
        expect(response).to have_http_status(:success)
        expect(json_response.size).to eq(1)
        end
    end

    context "as loved one" do
      it "returns unauthorized" do
        user.update(role: 'loved_one')
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET #show" do
    it "returns a specific answer" do
      get :show, params: { id: answer.id }
      expect(response).to have_http_status(:success)
      expect(json_response['content']).to eq(answer.content)
    end
  end

  describe "POST #create" do
    it "creates a new answer" do
      expect {
        post :create, params: { answer: { content: 'New Answer', question_id: answer.question_id } }
      }.to change(Answer, :count).by(1)
      expect(response).to have_http_status(:created) 
    end
  end

  describe "PATCH/PUT #update" do
    it "updates the answer" do
      patch :update, params: { id: answer.id, answer: { content: 'Updated Answer' } }
      answer.reload
      expect(answer.content).to eq('Updated Answer')
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the answer" do
      answer.save
      expect {
        delete :destroy, params: { id: answer.id }
      }.to change(Answer, :count).by(-1)
      expect(response).to have_http_status(:success)
    end
  end

  def json_response
    JSON.parse(response.body)
  end

end
