class User < ActiveRecord::Base
    has_many :questionnaires
    has_many :genres, through: :questionnaires
    has_many :movies, through: :genres
# add associatons!
end
