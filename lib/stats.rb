require 'scraper'
require 'stats/basketball_stats'

# Stats class
class Stats
  attr_reader :scraper

  def initialize(player)
    @scraper = Scraper.for_type(self.class).new(player)
  end

  def self.for_type(player)
    Object.const_get("#{player.class.to_s.match(/(\w+)Player/)[1]}Stats")
  end

  def season_stats(year = Time.now.year)
    scraper.parse_season_stats#[year]
  end
end
