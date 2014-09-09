require_relative '../../config/environment'
ActiveRecord::Base.logger = nil

describe "Rating" do
  describe "inheritance" do
    it "inherits from ActiveRecord::Base" do
      expect(Rating < ActiveRecord::Base).to be true
    end
  end

  describe "expected data" do
    it "Judge 1 should have rated Dog 2 a 7 on cuteness" do
      rating = Rating.find_by(judge_id: 1, dog_id: 2)

      expect(rating.cuteness).to eq 7
    end

    it "Judge 5's votes should be removed from the database" do
      judge_fives_votes = Rating.where(judge_id: 5)

      expect(judge_fives_votes).to be_empty
    end

    it "all cuteness ratings for Dog 1 should be a 10" do
      dog_1_non_10s_for_cuteness = Rating.where(dog_id: 1).where.not(cuteness: 10)

      expect(dog_1_non_10s_for_cuteness).to be_empty
    end

    it "Judge 6 should have rated Dog 3 a 4 for cuteness and a 7 for coolness" do
      rating = Rating.find_by(judge_id: 6, dog_id: 3, cuteness: 4, coolness: 7)

      expect(rating).to be_instance_of Rating
    end
  end
end
