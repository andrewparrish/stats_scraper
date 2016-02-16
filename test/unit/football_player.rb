require_relative '../test_helper'
require 'player'

class FootballPlayerTest < MiniTest::Test
  def setup
    @result_test_one = FootballPlayer.new('tony', 'romo', 'cowboys', 'QB')
  end

  def test_player_found
    @result_test_one.get_player_page
    assert @result_test_one.matches_player?
  end

  def test_player_multi_result_query
    assert true
  end
end
