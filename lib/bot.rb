require 'mechanize'

# Scraper
class Bot
  attr_accessor :bot, :type
  attr_reader :curr_url, :curr_page, :base_url, :base_search_url

  def initialize(type = Player)
    @bot = Mechanize.new
    @type = type
    @base_url = @type.base_url
    @base_search_url = @type.base_search_url
  end

  def go(url)
    @curr_page = bot.get(url)
    @curr_url = @curr_page.uri.to_s
  end

  def url_contains?(query)
    @curr_url.match(query)
  end

  def search(query)
    @curr_page.search(query)
  end

  def page_contains?(query)
    @curr_page.body.include?(query)
  end

  def players_page?
    case @type
    when FootballPlayer
      url_contains?(%r{players\/\d+})
    end
  end

  def player_found?(player_name)
    go(@base_search_url + player_name)
    players_page? || !page_contains?(@type.not_found_text)
  end

  def get_player(player_name)
    if player_found?(player_name)
      if player_page?

      else

      end
    end
    raise NoPlayerFound.new("Player: #{player_name} could not be found.")
  end
end
