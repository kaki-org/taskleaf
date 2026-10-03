# frozen_string_literal: true

require 'rails_helper'

describe 'タスクAPIのルーティング' do
  it 'show / update / destroy へルーティングされること' do
    expect(get: '/api/v1/tasks/1').to route_to('api/v1/tasks#show', id: '1')
    expect(put: '/api/v1/tasks/1').to route_to('api/v1/tasks#update', id: '1')
    expect(patch: '/api/v1/tasks/1').to route_to('api/v1/tasks#update', id: '1')
    expect(delete: '/api/v1/tasks/1').to route_to('api/v1/tasks#destroy', id: '1')
  end

  it '未実装の index / create / edit はルーティングされないこと' do
    expect(get: '/api/v1/tasks').not_to be_routable
    expect(post: '/api/v1/tasks').not_to be_routable
    expect(get: '/api/v1/tasks/1/edit').not_to be_routable
  end
end
