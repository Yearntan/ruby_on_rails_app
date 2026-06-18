require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user, :young_person) }
  let(:admin) { create(:user, :admin) }
  let(:supporter) { create(:user, :supporter) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:valid_attributes) { { content: "Answer content", question_id: question.id } }
  let(:invalid_attributes) { { content: "", question_id: question.id } }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is a loved_one" do
      before do
        user.update(role: "loved_one")
        get :index
      end

      it "calls manage_loved_one_access" do
        expect(controller).to receive(:manage_loved_one_access)
        get :index
      end
    end

    context "when user is a supporter" do
      before do
        sign_in supporter
      end

      it "calls manage_supporter_access" do
        expect(controller).to receive(:manage_supporter_access)
        get :index
      end
    end

    context "when user is an admin" do
      before do
        sign_in admin
        get :index
      end

      it "assigns all answers as @answers" do
        expect(assigns(:answers)).to eq(Answer.all)
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
      allow(controller).to receive(:set_answer).and_return(answer)
      get :show, params: { id: answer.id }
    end

    it "assigns the requested answer as @answer" do
      expect(assigns(:answer)).to eq(answer)
    end

    it "assigns the question associated with the answer as @question" do
      expect(assigns(:question)).to eq(answer.question)
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    before do
      get :new, params: { question_id: question.id }
    end

    it "assigns a new answer as @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "assigns the question as @question" do
      expect(assigns(:question)).to eq(question)
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
      allow(controller).to receive(:set_answer).and_return(answer)
      get :edit, params: { id: answer.id }
    end

    it "assigns the requested answer as @answer" do
      expect(assigns(:answer)).to eq(answer)
    end

    it "assigns the question associated with the answer as @question" do
      expect(assigns(:question)).to eq(answer.question)
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
      it "creates a new Answer" do
        expect {
          post :create, params: { answer: valid_attributes, question_id: question.id }
        }.to change(Answer, :count).by(1)
      end

      it "redirects to the questions path with a success notice" do
        post :create, params: { answer: valid_attributes, question_id: question.id }
        expect(response).to redirect_to(questions_path)
        expect(flash[:notice]).to eq('Answer was successfully created.')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Answer" do
        expect {
          post :create, params: { answer: invalid_attributes, question_id: question.id }
        }.not_to change(Answer, :count)
      end

      it "re-renders the new template with an alert" do
        post :create, params: { answer: invalid_attributes, question_id: question.id }
        expect(response).to render_template("new")
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH/PUT #update" do
    before do
      allow(controller).to receive(:set_answer).and_return(answer)
    end

    context "with valid parameters" do
      let(:new_attributes) { { content: "Updated content" } }

      it "updates the requested answer" do
        patch :update, params: { id: answer.id, answer: new_attributes }
        answer.reload
        expect(answer.content).to eq("Updated content")
      end

      it "redirects to the questions path with a success notice" do
        patch :update, params: { id: answer.id, answer: new_attributes }
        expect(response).to redirect_to(questions_path)
        expect(flash[:notice]).to eq('Answer was successfully updated.')
      end
    end

    context "with invalid parameters" do
      it "does not update the answer" do
        patch :update, params: { id: answer.id, answer: invalid_attributes }
        answer.reload
        expect(answer.content).not_to eq("")
      end

      it "re-renders the edit template with an alert" do
        patch :update, params: { id: answer.id, answer: invalid_attributes }
        expect(response).to render_template("edit")
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(controller).to receive(:set_answer).and_return(answer)
    end

    it "destroys the requested answer" do
      answer
      expect {
        delete :destroy, params: { id: answer.id }
      }.to change(Answer, :count).by(-1)
    end

    it "redirects to the answers list with a success notice" do
      delete :destroy, params: { id: answer.id }
      expect(response).to redirect_to(answers_url)
      expect(flash[:notice]).to eq('Answer was successfully destroyed.')
    end
  end

  describe "DELETE #remove_media" do
    let(:media_attachment) { create(:active_storage_attachment, record: answer) }

    it "removes the requested media attachment" do
      expect {
        delete :remove_media, params: { id: answer.id, media_id: media_attachment.id }
      }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    it "redirects back to the referer with a success notice" do
      request.env["HTTP_REFERER"] = answers_url
      delete :remove_media, params: { id: answer.id, media_id: media_attachment.id }
      expect(response).to redirect_to(answers_url)
      expect(flash[:notice]).to eq('Media was successfully removed.')
    end
  end

  describe "private methods" do
    describe "#set_answer" do
      it "sets the correct answer" do
        controller.params = { id: answer.id }
        controller.send(:set_answer)
        expect(assigns(:answer)).to eq(answer)
      end
    end

    describe "#answer_params" do
      let(:params) do
        ActionController::Parameters.new({
          answer: {
            content: 'Test content',
            question_id: question.id,
            bubble_ids: []
          }
        })
      end

      before do
        controller.params = params
      end

      it "permits the correct parameters" do
        permitted_params = controller.send(:answer_params)
        expect(permitted_params).to eq({
          "content" => 'Test content',
          "question_id" => question.id,
          "bubble_ids" => []
        })
      end
    end

    describe "#attach_media" do
      let(:media_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png') }
      let(:media_files) { [media_file] }

      it "attaches media to the record" do
        expect {
          controller.send(:attach_media, answer, media_files)
        }.to change(answer.media, :count).by(1)
      end

      it "does not attach media if file size exceeds the limit" do
        allow(media_file).to receive(:size).and_return(11.megabytes)
        expect {
          controller.send(:attach_media, answer, media_files)
        }.not_to change(answer.media, :count)
      end
    end

    describe "#ensure_young_person" do
      context "when user is a young person" do
        it "allows access" do
          expect(controller.send(:ensure_young_person)).to be_nil
        end
      end

      context "when user is not authorized" do
        before do
          allow(controller).to receive(:current_user).and_return(build(:user, role: "unauthorized"))
        end

        it "redirects to root_path with an alert" do
          controller.send(:ensure_young_person)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end

    describe "#manage_loved_one_access" do
      let(:bubble_member) { create(:bubble_member, user: user) }
      let(:bubble_invite) { create(:bubble_invite, bubble_member: bubble_member) }
      let(:bubble) { create(:bubble) }
      let(:answer_bubble) { create(:answers_bubble, bubble: bubble, answer: answer) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(BubbleMember).to receive(:find_by).with(user_id: user.id).and_return(bubble_member)
        allow(BubbleInvite).to receive(:where).with(bubble_member_id: bubble_member.id).and_return([bubble_invite])
        allow(bubble_invite).to receive(:bubbles).and_return([bubble])
        allow(bubble).to receive(:holder).and_return(double('Holder', passed_away: true))
        allow(AnswersBubble).to receive(:where).with(bubble_id: bubble.id).and_return([answer_bubble])
      end

      it "assigns answers for loved_one role" do
        controller.send(:manage_loved_one_access)
        expect(assigns(:answers)).to include(answer)
      end
    end

    describe "#manage_supporter_access" do
      let(:young_person) { create(:young_person, user: user) }

      context "when user_id is provided" do
        it "assigns answers for the specified young person" do
          allow(YoungPerson).to receive(:find_by).with(user_id: user.id).and_return(young_person)
          controller.params = { user_id: user.id }
          controller.send(:manage_supporter_access)
          expect(assigns(:answers)).to eq(young_person.answers)
        end

        it "redirects to supporter_dashboard_path if no young person is found" do
          controller.params = { user_id: user.id }
          allow(YoungPerson).to receive(:find_by).with(user_id: user.id).and_return(nil)
          controller.send(:manage_supporter_access)
          expect(response).to redirect_to(supporter_dashboard_path)
          expect(flash[:alert]).to eq("No young person found.")
        end
      end

      context "when user_id is not provided" do
        it "redirects to supporter_dashboard_path with an alert" do
          controller.params = { user_id: nil }
          controller.send(:manage_supporter_access)
          expect(response).to redirect_to(supporter_dashboard_path)
          expect(flash[:alert]).to eq("No young person selected.")
        end
      end
    end
  end
end

