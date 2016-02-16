require 'mechanize'

# Scraper
class Bot
  attr_accessor :bot, :type
  attr_reader :curr_url, :curr_page, :base_url, :base_search_url

  def initialize(player)
    @bot = Mechanize.new
    @bot.follow_meta_refresh = true
    @player = player
    @base_url = @player.class.base_url
    @base_search_url = @player.class.base_search_url
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

  def go_to_search_page(player_name)
    go(@base_search_url + player_name)
  end

  def player_page?
    case @player
    when FootballPlayer
      return url_contains?(%r{players\/\d+}) || false
    end
  end

  def player_found?(player_name)
    go_to_search_page(player_name)
    player_page? || !page_contains?(@player.class.not_found_text)
  end

  def get_player_page(player_name)
    if player_found?(player_name)
      if player_page?
        return @curr_url if @player.matches_player?
      elsif @player.handle_results?
        return @curr_url if @player.handle_results?
      end
    end
    raise NoPlayerFound.new("Player: #{player_name} could not be found.")
  end
end
