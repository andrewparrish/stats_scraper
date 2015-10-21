class NoPlayerFound < Exception ; end

#Super class to save basic player for all sports info
class Player

	def initialize(name, number, team)
		@name = name
		@number = number
		@team = team
	end

	def self.bot
		if defined? @@bot
			@@bot 
		else
			@@bot = Mechanize.new
		end
	end
end

class FootballPlayer < Player

	def initialize(position)
		@position = position
	end

	def self.base_url
		"http://fftoday.com"
	end

	def self.base_search_url
		"http://fftoday.com/stats/players?Search="
	end

	def self.search_player(query)
		page = bot.get(base_search_url + query)
		curr_url = page.uri.to_s
		#First if this is a player stat page we're in the right place
		if curr_url.match(/players\/\d+/)
			return page	
		#Otherwise we need to see if there are multipe results, or no results
		else
			#Throw an error if no player is found
			raise NoPlayerFound.new("Shit hapens") if page.body.include?("No players found.")
			#Otherwise we need to return an array of results that were found.
			return page.search("//span[@class='bodycontent']").map{|t| t.children[0]["href"] }
		end
	end
end

class SoccerPlayer < Player ; end
