# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskMailer do
  describe '#creation_email' do
    let(:task) { create(:task, name: 'メイラーSpecを書く', description: '送信したメールの内容を確認します') }
    let(:mail) { described_class.creation_email(task) }
    let(:text_body) { mail.text_part.body.raw_source }
    let(:html_body) { mail.html_part.body.raw_source }

    it 'sends an email with expected headers and body' do
      expect(mail.subject).to eq('タスク作成完了メール')
      expect(mail.to).to eq(['user@example.com'])
      expect(mail.from).to eq(['taskleaf@example.com'])

      expect(text_body).to include('以下のタスクを作成しました')
      expect(text_body).to include('メイラーSpecを書く')
      expect(text_body).to include('送信したメールの内容を確認します')

      expect(html_body).to include('以下のタスクを作成しました')
      expect(html_body).to include('メイラーSpecを書く')
      expect(html_body).to include('送信したメールの内容を確認します')
    end
  end
end
