# frozen_string_literal: true

require 'rails_helper'

describe 'ログイン機能', :js do
  let(:user) { create(:user, name: 'ユーザA', email: 'a@example.com') }

  context '日本語対応ブラウザでログイン画面をみたとき' do
    let(:headers) do
      { 'Accept-Language': 'ja-JP' }
    end

    before do
      visit login_path
    end

    it 'こんにちわとでている' do
      page.save_screenshot 'page.png'
      expect(page).to have_content('こんにちわ')
    end
  end

  # context '英語対応ブラウザでログイン画面にくると' do
  #   xbefore { visit login_path, params: { headers: 'Accept-Language: en'} }
  #   xit 'Hello Worldとでている' do
  #     expect(page).to have_content('Hello World')
  #   end
  # end
  context 'まちがったユーザ名とパスワードを入力したとき' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'invalid'
    end

    it 'エラー画面が表示される' do
      click_link_or_button 'ログインする'
      expect(page).to have_content('ログインに失敗しました')
    end
  end

  context '正しいユーザ名とパスワードを入力したとき' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
    end

    it 'トップ画面に遷移する' do
      click_link_or_button 'ログインする'
      expect(page).to have_current_path root_path
    end
  end

  context 'ログアウトするとき' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_link_or_button 'ログインする'
      visit root_path
    end

    it 'ログアウトしました表示が出る' do
      click_link_or_button 'ログアウト'
      expect(page).to have_content('ログアウトしました')
    end
  end
end
