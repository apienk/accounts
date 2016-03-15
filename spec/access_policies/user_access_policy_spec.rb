require 'rails_helper'

RSpec.describe UserAccessPolicy do

  let!(:anon)      { AnonymousUser.instance }
  let!(:temp)      { FactoryGirl.create :temp_user }
  let!(:user)      { FactoryGirl.create :user }
  let!(:admin)     { FactoryGirl.create :user, :admin }
  let!(:app)       { FactoryGirl.create :doorkeeper_application }

  context 'login_help' do
    it 'cannot be accessed by applications' do
      [:login_help].each do |action|
        expect(OSU::AccessPolicy.action_allowed?(action, app, User)).to eq false
      end
    end

    it 'can be accessed by human users' do
      [:login_help].each do |action|
        expect(OSU::AccessPolicy.action_allowed?(action, anon, User)).to eq true
        expect(OSU::AccessPolicy.action_allowed?(action, temp, User)).to eq true
        expect(OSU::AccessPolicy.action_allowed?(action, user, User)).to eq true
        expect(OSU::AccessPolicy.action_allowed?(action, admin, User)).to eq true
      end
    end
  end

  context 'search' do
    it 'cannot be accessed by anonymous or temp users' do
      expect(OSU::AccessPolicy.action_allowed?(:search, anon, User)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:search, temp, User)).to eq false
    end

    it 'can be accessed by non-temp users' do
      expect(OSU::AccessPolicy.action_allowed?(:search, user, User)).to eq true
      expect(OSU::AccessPolicy.action_allowed?(:search, admin, User)).to eq true
      expect(OSU::AccessPolicy.action_allowed?(:search, app, User)).to eq true
    end
  end

  context 'read, update' do
    it 'cannot be accessed by anonymous users or apps' do
      expect(OSU::AccessPolicy.action_allowed?(:read, anon, anon)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:read, app, user)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:update, anon, anon)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:update, app, user)).to eq false
    end

    it 'can be accessed by human users, temp or not' do
      expect(OSU::AccessPolicy.action_allowed?(:read, user, user)).to eq true
      expect(OSU::AccessPolicy.action_allowed?(:read, admin, admin)).to eq true
      expect(OSU::AccessPolicy.action_allowed?(:read, temp, temp)).to eq true

      expect(OSU::AccessPolicy.action_allowed?(:update, user, user)).to eq true
      expect(OSU::AccessPolicy.action_allowed?(:update, admin, admin)).to eq true
      expect(OSU::AccessPolicy.action_allowed?(:update, temp, temp)).to eq true
    end

    it 'cannot access other users unless admin' do
      expect(OSU::AccessPolicy.action_allowed?(:read, user, admin)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:read, admin, user)).to eq true

      expect(OSU::AccessPolicy.action_allowed?(:update, user, admin)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:update, admin, user)).to eq true
    end
  end

  context 'register' do
    it 'cannot be accessed by anonymous, non-temp users or apps' do
      expect(OSU::AccessPolicy.action_allowed?(:register, anon, anon)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:register, user, user)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:register, admin, admin)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:register, app, user)).to eq false
    end

    it 'can be accessed by temp users' do
      expect(OSU::AccessPolicy.action_allowed?(:register, temp, temp)).to eq true
    end

    it 'cannot access other users' do
      expect(OSU::AccessPolicy.action_allowed?(:register, temp, user)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:register, temp, admin)).to eq false
    end
  end

end
