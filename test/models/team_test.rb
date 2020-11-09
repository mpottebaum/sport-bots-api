require 'test_helper'

class TeamTest < ActiveSupport::TestCase

  setup do
    @fixture_team = teams(:fixture_team)
    @fixture_team.generate_bots
    @roster = @fixture_team.generate_roster
  end

  test "unique name validation" do
    team = Team.create({
      name: 'Fixture Team',
      email: 'new@new.com',
      password: 'new',
    })
    assert !team.valid?
  end

  test "unique email validation" do
    team = Team.create({
      name: 'New Team',
      email: 'fixture@fixture.com',
      password: 'new',
    })
    assert !team.valid?
  end

  test "team generates 100 bots with attribute constraints" do
    assert_equal 100, @fixture_team.bots.length
  end

  test "team's generated bots fit attribute constraints" do
    are_bots_valid = @fixture_team.bots.all? do |bot|
      if bot.speed > 50 || bot.speed < 1
        return false
      elsif bot.strength > 50 || bot.strength < 1
        return false
      elsif bot.agility > 50 || bot.agility < 1
        return false
      elsif bot.attributes_sum > 100
        return false
      else
        return true
      end
    end

    assert are_bots_valid
  end

  test "random roster has 10 starters" do
    assert_equal 10, @roster[:starters].length
  end
  
  test "random roster has 5 alternates" do
    assert_equal 5, @roster[:alternates].length
  end

  test "random roster has no duplicated attribute sums" do
    all_players = @roster[:starters] + @roster[:alternates]
    sums_lib = {}
    is_roster_valid = true
    all_players.each do |bot|
      att_sum = bot.attributes_sum
      if sums_lib[att_sum]
        is_roster_valid = false
      else
        sums_lib[att_sum] = true
      end
    end

    assert is_roster_valid
  end

  
end
