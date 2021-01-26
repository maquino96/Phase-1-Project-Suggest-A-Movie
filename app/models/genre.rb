class Genre < ActiveRecord::Base
  belongs_to :movie
  belongs_to :questionnaire
  # add associatons!
end
