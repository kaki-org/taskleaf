# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is invalid without a name' do
      task = build(:task, name: nil)
      expect(task).to be_invalid
      expect(task.errors[:name]).to include('を入力してください')
    end
  end

  describe 'associations' do
    let!(:user) { create(:user) }
    let!(:tasks) { create_list(:task, 2, user:, name: 'rspec test') }
    it 'can have multiple tasks' do
      expect(user.tasks.where(name: 'rspec test').count).to eq(2)
    end
  end
end
