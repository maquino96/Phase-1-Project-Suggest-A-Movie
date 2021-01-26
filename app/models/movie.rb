class Movie < ActiveRecord::Base
    has_many :genres
    has_many :questionnaires, through: :genres
    has_many :users, through: :questionnaires
    # add associatons!
  end