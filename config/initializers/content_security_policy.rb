# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, :data
    policy.img_src     :self, :data
    policy.object_src  :none
    policy.script_src  :self
    policy.style_src   :self

    # Vite dev server: HMR の WebSocket と、Vite が JS から注入する <style> を許可する
    # （Vite は meta[property=csp-nonce] を探すが csp_meta_tag は name 属性のため nonce を渡せない）
    # HMR の接続先はアクセスしたホスト名（localhost / lvh.me / 127.0.0.1 など）になるため、ws: スキームごと許可する
    if Rails.env.development?
      policy.connect_src :self, :ws
      policy.style_src   :self, :unsafe_inline
    end
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate per-request random nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  # style-src に nonce が付くと unsafe-inline が無視されるため、development では script-src のみに付ける
  config.content_security_policy_nonce_directives = Rails.env.development? ? %w[script-src] : %w[script-src style-src]

  # Report violations without enforcing the policy.
  # config.content_security_policy_report_only = true
end
