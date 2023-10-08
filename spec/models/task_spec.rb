# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }

    it 'is invalid without a name' do
      task = build(:task, name: nil)
      expect(task).not_to be_valid
      expect(task.errors[:name]).to include('を入力してください')
    end

    context 'when name includes a comma' do
      let(:task) { build(:task, name: 'Task with, comma') }

      it 'is invalid' do
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('にカンマを含める事はできません')
      end
    end
  end

  describe 'associations' do
    let!(:user) { create(:user) }
    let!(:tasks) { create_list(:task, 2, user:, name: 'rspec test') }

    it 'can have multiple tasks' do
      expect(user.tasks.where(name: 'rspec test').count).to eq(2)
    end

    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'scopes' do
    describe '.recent' do
      xit 'orders tasks by created_at in descending order' do
        old_task = create(:task, created_at: 1.day.ago)
        new_task = create(:task)

        expect(described_class.recent).to eq([new_task, old_task])
      end
    end
  end

  describe '.csv_attributes' do
    it 'returns an array of attribute names' do
      expect(described_class.csv_attributes).to eq(%w[name description created_at updated_at])
    end
  end

  describe '.generate_csv' do
    xit 'generates a CSV file with all tasks' do
      task1 = create(:task, name: 'Task 1', description: 'Description 1')
      task2 = create(:task, name: 'Task 2', description: 'Description 2')

      csv = described_class.generate_csv
      expected_csv = "name,description,created_at,updated_at\nTask 1,Description 1,#{task1.created_at},#{task1.updated_at}\nTask 2,Description 2,#{task2.created_at},#{task2.updated_at}\n"

      expect(csv).to eq(expected_csv)
    end
  end

  describe '.import' do
    let(:file) { fixture_file_upload('tasks.csv', 'text/csv') }

    xit 'imports tasks from a CSV file' do
      expect do
        described_class.import(file)
      end.to change(described_class, :count).by(2)

      expect(described_class.last.name).to eq('Task 2')
    end
  end

  describe '.ransackable_attributes' do
    it 'returns an array of attribute names' do
      expect(described_class.ransackable_attributes).to eq(%w[name created_at])
    end
  end

  describe '.ransackable_associations' do
    it 'returns an empty array' do
      expect(described_class.ransackable_associations).to eq([])
    end
  end
end
