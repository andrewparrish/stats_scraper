require 'bot'
require 'stats'

class NoPlayerFound < Exception; end

# Super class to save basic player for all sports info
class Player
  attr_reader :bot, :first_name, :last_name, :stats_page, :team, :stats

  def initialize(first_name, last_name, team)
    @first_name = first_name.downcase
    @last_name = last_name.downcase
    @team = team
    @bot = Bot.new(self)
    @stats_page = search_player
    @stats = Stats.for_type(self).new(self)
  end

  def self.not_found_text
    raise(NotImplementedError, not_implemented_err_msg('not_found_text'))
  end

  def handle_results
    raise(NotImplementedError, not_implemented_err_msg('handles_results'))
  end

  def matches_player?
    raise(NotImplementedError, not_implemented_err_msg('matches_player?'))
  end

  def search_query
    raise(NotImplementedError, not_implemented_err_msg('search_query'))
  end

  def name_match?(name_arr)
    @first_name.casecmp(name_arr[0]) == 0 && @last_name.casecmp(name_arr[1]) == 0
  end


  def search_player(query = nil)
    @bot.get_player_page(query || search_query)
  end

  def player_page
    @bot.go(@stats_page)
  end

  def results_pages_match?(results_pages)
    results_pages.each do |url|
      @bot.go(url)
      return true if matches_player?
    end
    false
  end

  private

  def not_implemented_err_msg(method)
    "#{self.class} hasn't implemented #{method}"
  end
end

class FootballPlayer < Player
  def initialize(first_name, last_name, team, position)
    super(first_name, last_name, team)
    @position = position
  end

  def self.base_url
    'http://fftoday.com'
  end

  def self.base_search_url
    'http://fftoday.com/stats/players?Search='
  end

  def self.not_found_text
    'No players found.'
  end

  def handle_results?
    @bot.go_to_search_page("#{@last_name},#{@first_name}")
    results_pages = @bot.search("//span[@class='bodycontent']").map do |t|
      t.children[0]['href']
    end
    results_pages_match?(results_pages)  
  end

  def matches_player?
    name = @bot.search("//td[@class='pageheader']")[0].text.rstrip.split(' ')
    name_match?(name)
  end

  def search_query
    @last_name
  end
end

class SoccerPlayer < Player; end
