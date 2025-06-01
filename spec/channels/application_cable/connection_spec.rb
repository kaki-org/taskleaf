# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection do
  it 'ActionCable::Connection::Baseのサブクラスであること' do
    expect(described_class).to be < ActionCable::Connection::Base
  end
end
