# frozen_string_literal: true

require 'rails_helper'

describe 'ログイン機能', type: :system, js: true do
  let(:user) { create(:user, name: 'ユーザA', email: 'a@example.com') }
  context '日本語対応ブラウザでログイン画面にくると' do
    let(:headers) do
      { "Accept-Language": 'ja-JP' }
    end
    before do
      @origin_headers = page.driver.options[:headers]
      page.driver.options[:headers] ||= {}
      page.driver.options[:headers].merge!(headers)
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
  context 'まちがったユーザ名とパスワードを入力' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'invalid'
    end
    it 'エラー画面が表示される' do
      click_button 'ログインする'
      expect(page).to have_content('ログインに失敗しました')
    end
  end
  context '正しいユーザ名とパスワードを入力' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
    end
    it 'トップ画面に遷移する' do
      click_button 'ログインする'
      visit root_path
    end
  end
  context 'ログアウトする' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログインする'
      visit root_path
    end
    it 'ログアウトしました表示が出る' do
      click_on 'ログアウト'
      expect(page).to have_content('ログアウトしました')
    end
  end
end
