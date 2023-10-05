class Movie < ActiveRecord::Base

def self.with_ratings(ratings_list)
  if ratings_list.present?
    where(rating: ratings_list)
  else
    all
  end
end

end
