# frozen_string_literal: true

class Task < ApplicationRecord
  # before_validation :set_nameless_name
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user
  has_one_attached :image

  def display_name
    if name.length > 20
      "#{name[0...17]}..."
    else
      name
    end
  end

  scope :recent, -> { order(created_at: :desc) }

  class << self
    def csv_attributes
      %w[name description created_at updated_at]
    end

    def generate_csv
      CSV.generate(headers: true) do |csv|
        csv << csv_attributes
        find_each do |task|
          csv << csv_attributes.map { |attr| task.send(attr) }
        end
      end
    end

    def import(file)
      return unless file

      CSV.foreach(file.path, headers: true) do |row|
        task = new
        task.attributes = row.to_hash.slice(*csv_attributes)
        task.save!
      end
    end

    def ransackable_attributes(_auth_object = nil)
      %w[name created_at]
    end

    def ransackable_associations(_auth_object = nil)
      []
    end
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含める事はできません') if name&.include?(',')
  end
end
