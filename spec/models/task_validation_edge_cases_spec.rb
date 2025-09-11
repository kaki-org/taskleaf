# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  describe 'edge cases and validations' do
    describe 'name validation with comma' do
      it 'is invalid when name contains comma' do
        task = build(:task, name: 'Task with, comma', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('にカンマを含める事はできません')
      end

      it 'is invalid when name starts with comma' do
        task = build(:task, name: ',Task starts with comma', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('にカンマを含める事はできません')
      end

      it 'is invalid when name ends with comma' do
        task = build(:task, name: 'Task ends with comma,', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('にカンマを含める事はできません')
      end

      it 'is valid when name has no comma' do
        task = build(:task, name: 'Task without comma', user: user)
        expect(task).to be_valid
      end
    end

    describe 'name length validation' do
      it 'is valid with maximum length (30 characters)' do
        task = build(:task, name: 'a' * 30, user: user)
        expect(task).to be_valid
      end

      it 'is invalid when name exceeds 30 characters' do
        task = build(:task, name: 'a' * 31, user: user)
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('は30文字以内で入力してください')
      end
    end

    describe 'name presence validation with edge cases' do
      it 'is invalid with nil name' do
        task = build(:task, name: nil, user: user)
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('を入力してください')
      end

      it 'is invalid with empty string name' do
        task = build(:task, name: '', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('を入力してください')
      end

      it 'is invalid with whitespace-only name' do
        task = build(:task, name: '   ', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('を入力してください')
      end
    end
  end

  describe 'display_name method edge cases' do
    context 'when name is exactly 20 characters' do
      it 'returns the full name' do
        task = build(:task, name: 'a' * 20)
        expect(task.display_name).to eq('a' * 20)
      end
    end

    context 'when name is exactly 21 characters' do
      it 'returns truncated name with ellipsis' do
        task = build(:task, name: 'a' * 21)
        expect(task.display_name).to eq("#{'a' * 17}...")
      end
    end

    context 'when name is much longer than 20 characters' do
      it 'returns truncated name with ellipsis' do
        task = build(:task, name: 'This is a very long task name that exceeds twenty characters')
        expect(task.display_name).to eq('This is a very lo...')
      end
    end
  end

  describe 'CSV import edge cases' do
    let(:user) { build(:user) }

    before do
      user.tasks.clear # Clear any tasks created by factory
      user.save!
    end

    context 'when importing with nil file' do
      it 'returns early without creating tasks' do
        expect { user.tasks.import(nil) }.not_to change(described_class, :count)
      end
    end
  end

  describe 'ransack configuration' do
    it 'allows searching by name' do
      expect(described_class.ransackable_attributes).to include('name')
    end

    it 'allows searching by created_at' do
      expect(described_class.ransackable_attributes).to include('created_at')
    end

    it 'does not allow searching by other attributes' do
      ransackable = described_class.ransackable_attributes
      expect(ransackable).not_to include('description')
      expect(ransackable).not_to include('user_id')
    end

    it 'has empty ransackable associations' do
      expect(described_class.ransackable_associations).to eq([])
    end
  end
end
