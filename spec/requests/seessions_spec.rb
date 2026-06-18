require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "renders the login template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in the user and redirects to the user's show page" do
        post :create, params: { session: { email: user.email, password: user.password } }
        expect(session[:user_id]).to eq(user.id)
        expect(flash[:success]).to match(/You have been logged in, user id is:/)
        expect(response).to redirect_to(user)
      end

      it "calls the log_in method" do
        expect(controller).to receive(:log_in).with(user)
        post :create, params: { session: { email: user.email, password: user.password } }
      end
    end

    context "with invalid credentials" do
      it "re-renders the login template with a flash message" do
        post :create, params: { session: { email: user.email, password: 'wrongpassword' } }
        expect(session[:user_id]).to be_nil
        expect(flash.now[:danger]).to match(/Invalid email\/password combination/)
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      session[:user_id] = user.id
    end

    it "logs out the user and redirects to the home page" do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(flash[:success]).to match(/You have been logged out/)
      expect(response).to redirect_to(root_url)
    end

    it "resets the session" do
      expect(controller).to receive(:reset_session)
      delete :destroy
    end
  end

  describe "private methods" do
    describe "#log_in" do
      it "sets the session user_id" do
        controller.send(:log_in, user)
        expect(session[:user_id]).to eq(user.id)
      end
    end

    describe "#log_out" do
      it "deletes the session user_id" do
        session[:user_id] = user.id
        controller.send(:log_out)
        expect(session[:user_id]).to be_nil
      end
    end
  end
end
