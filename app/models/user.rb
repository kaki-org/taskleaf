# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_many :tasks, dependent: :destroy

  def self.by_letter(letter)
    where("name LIKE ?", "#{letter}%").order(:name)
  end
end
