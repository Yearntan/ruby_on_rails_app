require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'User' do
    context 'when is an admin' do
      let(:user) { User.create!(admin: true) }  # Adjust user creation to match your user model
      let(:ability) { Ability.new(user) }

      it 'can manage all' do
        expect(ability).to be_able_to(:manage, :all)
      end
    end

    context 'when is a regular user' do
      let(:user) { User.create!(admin: false) }  # Adjust user creation to match your user model
      let(:ability) { Ability.new(user) }

      it 'can read all' do
        expect(ability).to be_able_to(:read, :all)
      end

      it 'cannot manage all' do
        expect(ability).not_to be_able_to(:manage, :all)
      end

      it 'can update only their own profile' do
        other_user = User.create!(admin: false)
        expect(ability).to be_able_to(:update, user)
        expect(ability).not_to be_able_to(:update, other_user)
      end
    end

    context 'when is a guest (no user)' do
      let(:ability) { Ability.new(nil) }

      it 'cannot manage any resources' do
        expect(ability).not_to be_able_to(:manage, :all)
      end

      it 'can read public resources' do
        expect(ability).to be_able_to(:read, PublicResource)
      end
    end
  end
end
