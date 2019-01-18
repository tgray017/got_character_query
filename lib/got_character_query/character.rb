class Character
  attr_reader :name, :link_to_bio, :overview
  
  @@all = []
  
  def self.all
    @@all
  end
  
  def initialize(name, link_to_bio = "N/A", overview)
    @name = name
    @link_to_bio = link_to_bio
    unless link_to_bio == "N/A"
      Scraper.scrape_character_properties(self, link_to_bio)
    end
    @overview = overview
    @@all << self
  end
  
end