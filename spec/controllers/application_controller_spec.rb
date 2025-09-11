# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'test'
    end
  end

  describe '#current_user' do
    context 'when user_id is in session' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'returns the user' do
        expect(controller.send(:current_user)).to eq(user)
      end

      it 'memoizes the user' do
        expect(User).to receive(:find_by).once.and_return(user)
        2.times { controller.send(:current_user) }
      end
    end

    context 'when user_id is not in session' do
      it 'returns nil' do
        expect(controller.send(:current_user)).to be_nil
      end
    end

    context 'when user_id in session does not exist in database' do
      before do
        session[:user_id] = 999_999 # non-existent user id
      end

      it 'returns nil' do
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end

  describe '#login_required' do
    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'allows access' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe 'helper_method :current_user' do
    it 'makes current_user available in views' do
      expect(controller.class._helper_methods).to include(:current_user)
    end
  end
end
