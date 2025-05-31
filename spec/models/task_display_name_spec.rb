# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, '#display_name' do
  context '20文字より小さい長さのとき' do
    let(:task) { build(:task, name: 'Short name') }

    it '名前が全部返る' do
      expect(task.display_name).to eq('Short name')
    end
  end

  context '20文字を超える長さのとき' do
    let(:task) { build(:task, name: 'This is a very long task name that should be truncated') }

    it '名前が省略記号付きで切り詰められて返る' do
      expect(task.display_name).to eq('This is a very lo...')
    end
  end
end
