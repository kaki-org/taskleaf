# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Channel do
  it 'ActionCable::Channel::Baseのサブクラスであること' do
    expect(described_class).to be < ActionCable::Channel::Base
  end
end