require 'bot'

class NoPlayerFound < Exception; end

# Super class to save basic player for all sports info
class Player
  attr_reader :bot, :first_name, :last_name

  def initialize(first_name, last_name, team)
    @first_name = first_name.downcase
    @last_name = last_name.downcase
    @team = team
    @bot = Bot.new(self)
    @stats_page = search_player
  end

  def handle_results
    raise NotImplementedError.new("#{self.class} hasn't implemented handle_results")
  end

  def matches_player?
    raise NotImplementedError.new("#{self.class} hasn't implemented matches_player")
  end

  def name_match?(name_arr)
    @first_name == name_arr[0].downcase && @last_name == name_arr[1].downcase
  end

  def search_player
    raise NotImplementedError.new("#{self.class} hasn't implemented matches_player")
  end

  def get_player_page
    @bot.go(@stats_page)
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
    results_pages.each do |url|
      @bot.go(url)
      return true if matches_player?
    end
    false
  end

  def matches_player?
    name = @bot.search("//td[@class='pageheader']")[0].text.rstrip.split(' ')
    name_match?(name)
  end

  def search_query
    @last_name
  end

  def search_player(query = nil)
    @bot.get_player_page(query || search_query)
  end
end

class SoccerPlayer < Player; end
