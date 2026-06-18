require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#resource_name" do
    it "returns :user" do
      expect(helper.resource_name).to eq(:user)
    end
  end

  describe "#resource_class" do
    it "returns User" do
      expect(helper.resource_class).to eq(User)
    end
  end

  describe "#resource" do
    it "returns a new User instance" do
      expect(helper.resource).to be_a_new(User)
    end

    it "memoizes the resource" do
      user_instance = helper.resource
      expect(helper.resource).to equal(user_instance)
    end
  end

  describe "#devise_mapping" do
    it "returns the Devise mapping for :user" do
      expect(helper.devise_mapping).to eq(Devise.mappings[:user])
    end

    it "memoizes the devise mapping" do
      mapping_instance = helper.devise_mapping
      expect(helper.devise_mapping).to equal(mapping_instance)
    end
  end
end
