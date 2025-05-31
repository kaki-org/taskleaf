# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, 'display methods' do
  describe '#display_name' do
    context 'when name is shorter than 20 characters' do
      let(:task) { build(:task, name: 'Short name') }

      it 'returns the full name' do
        expect(task.display_name).to eq('Short name')
      end
    end

    context 'when name is longer than 20 characters' do
      let(:task) { build(:task, name: 'This is a very long task name that should be truncated') }

      it 'returns the truncated name with ellipsis' do
        expect(task.display_name).to eq('This is a very lo...')
      end
    end
  end
end