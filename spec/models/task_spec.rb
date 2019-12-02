# frozen_string_literal: true

# require 'rspec'
require 'rails_helper'

describe 'Task' do
  it '名前がないタスクは登録できない事' do
    expect { create!(:default_task, name: nil).to raise_error(ActiveRecord::RecordInvalid) }
  end
  it '一度に複数のタスクを持つことができる事' do
    user = create(:user)
    create(:default_task, user: user)
    mass_task = create(:mass_task, user: user)
    mass_task.valid?
    expect(mass_task).to be_valid
  end
end
