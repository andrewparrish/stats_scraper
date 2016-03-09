require 'Player'

# BasketballPlayer
class BasketballPlayer < Player
  def initialize(first_name, last_name, team)
    super(first_name, last_name, team)
  end

  def self.base_url
    'http://www.basketball-reference.com'
  end

  def self.base_search_url
    'http://www.basketball-reference.com/search/search.fcgi?search='
  end

  def self.not_found_text
    'Found 0 hits that match your search.'
  end

  def search_query
    "#{first_name}%20#{last_name}"
  end

  def handle_results?
    @bot.go_to_search_page(search_query)
    results_page_divs = @bot.search("//div[@class='search-item']/div/a")
    results = results_page_divs.to_a.reject! do |result|
      result.children[0].text.match(Date.today.year.to_s).nil?
    end
    results.map { |div| div.attributes['href'].value }.each do |url|
      @bot.go(self.class.base_url + url)
      return true if matches_player?
    end
    false
  end

  def matches_player?
    name = bot.search("//div[@class='person_image_offset']/h1")[0].children.text
    return false unless name_match?(name.split(' '))
    team = bot.search("//div[@class='poptip']").last.attributes['tip'].value
    @team.casecmp(team.split(',')[0]) == 0
  end
end
