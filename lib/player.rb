class NoPlayerFound < Exception; end

# Super class to save basic player for all sports info
class Player
  attr_reader :bot

  def initialize(first_name, last_name, number, team)
    @first_name = first_name
    @last_name = last_name
    @number = number
    @team = team
    @bot = Bot.new(self.class)
    @stats_page
  end

  def handle_results
    raise NotImplementedError.new("#{self.class} hasn't implemented handle_results")
  end

  def matches_player?
    raise NotImplementedError.new("#{self.class} hasn't implemented matches_player")
  end

  def name_match?(name_arr)
    @first_name == name_arr[0] && @last_name == name_arr[1]
  end

  def find

  end
end

class FootballPlayer < Player
  def initialize(position)
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

  def handle_results
    @bot.search("//span[@class='bodycontent']").map do |t|
      t.children[0]['href']
    end
  end

  def matches_player?
    name = @bot.search("//td[@class='pageheader']")[0].text.rstrip.split(' ')
    name_match?(name)
  end

  def self.search_player(query)
    page = bot.get(base_search_url + query)
    curr_url = page.uri.to_s
    # First if this is a player stat page we're in the right place
    if curr_urr =~ %r{players\/\d+}
      return page
      #Otherwise we need to see if there are multipe results, or no results
    else
      raise NoPlayerFound.new('Shit hapens') if page.body.include?('No players found.')
      #Otherwise we need to return an array of results that were found.
      return page.search("//span[@class='bodycontent']").map{|t| t.children[0]['href'] }
    end
  end
end

class SoccerPlayer < Player; end
