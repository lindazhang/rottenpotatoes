class Movie < ActiveRecord::Base

  def self.ratings
    @all_ratings = Array.new
    self.select("DISTINCT(rating)").each do |c|
	@all_ratings << c.rating
    end
    return @all_ratings  
  end

end
