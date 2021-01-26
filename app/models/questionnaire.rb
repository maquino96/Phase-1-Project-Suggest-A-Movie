class Questionnaire < ActiveRecord::Base
  belongs_to :user
  has_many :genres
  has_many :movies, through: :genres
  # add associatons!
end
