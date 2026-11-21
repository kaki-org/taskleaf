# frozen_string_literal: true

require 'rails_helper'

# Renovate の playwright グループは各パッケージを最新版へ上げるため、
# Ruby クライアントが対応する版と Node ドライバ・ブラウザサーバーの版がずれることがある。
# ずれたまま system spec を流すと接続時に失敗するため、ここで検出する。
RSpec.describe Playwright do
  describe 'COMPATIBLE_PLAYWRIGHT_VERSION' do
    let(:compatible_version) { described_class::COMPATIBLE_PLAYWRIGHT_VERSION }

    it 'package.json の @playwright/test と一致すること' do
      package_json = JSON.parse(Rails.root.join('package.json').read)
      expect(package_json.dig('devDependencies', '@playwright/test')).to eq(compatible_version)
    end

    it 'ブラウザサーバーの Dockerfile の版と一致すること' do
      dockerfile = Rails.root.join('devenv/playwright/Dockerfile').read
      expect(dockerfile[/^ARG PLAYWRIGHT_VERSION=(\S+)$/, 1]).to eq(compatible_version)
    end
  end
end
