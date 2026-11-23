# frozen_string_literal: true

InertiaRails.configure do |config|
  # フロントエンドのビルドが変わったらフルリロードさせる
  # 本番はデプロイ単位でしか変わらないため起動時に一度だけ計算し、それ以外はリクエストごとに評価する
  config.version = Rails.env.production? ? ViteRuby.digest : -> { ViteRuby.digest }
  config.always_include_errors_hash = true
  config.use_script_element_for_initial_page = true
end
