require 'bot'
require 'scrapers/basketball_scraper'
require 'yaml'

# Top level scraper class
class Scraper
  attr_reader :bot

  def initialize(player)
    @bot = Bot.new(player)
    @bot.go(player.stats_page)
  end

  def self.for_type(klass)
    Object.const_get("#{klass.to_s.match(/(\w+)Stats/)[1]}Scraper")
  end

  def season_stats
    bot.go(player.stats_page)
    parse_season_stats
  end

  def self.mapping_file
    raise(NotImplementedError, not_implemented_err_msg('mapping_file'))
  end

  def parse_season_stats
    raise(NotImplementedError, not_implemented_err_msg('parse_season_stats'))
  end

  def header_mapping
    YAML.load_file(self.class.mapping_file_path)
  end

  private

  def not_implemented_err_msg(method)
    "#{self.class} hasn't implemented #{method}"
  end
end
