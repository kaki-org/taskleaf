# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  # admin は NOT NULL なので、空文字が nil にキャストされても保存時の 500 ではなくバリデーションエラーにする
  validates :admin, inclusion: { in: [true, false] }

  has_many :tasks, dependent: :destroy

  def self.by_letter(letter)
    where('name LIKE ?', "#{letter}%").order(:name)
  end
end
