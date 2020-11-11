require 'test_helper'

class RosterTest < ActiveSupport::TestCase
  setup do
    @fixture_team = teams(:fixture_team)
    @fixture_team.generate_bots
    divided_valid_roster = @fixture_team.generate_roster
    combined_valid_roster = [divided_valid_roster[:starters], divided_valid_roster[:alternates]].flatten
    param_valid_roster = combined_valid_roster.map.with_index  do |bot, i|
      {
        bot_id: bot.id,
        designation: i > 9 ? 'alternate' : 'starter'
      }
    end

    @valid_roster_params = {
        players_attributes: param_valid_roster
    }
    extra_bot = @fixture_team.bots.sample(1)[0]
    param_too_many_players = param_valid_roster.push({ bot_id: extra_bot.id, designation: 'starter'})
    @too_many_params = {
        players_attributes: param_too_many_players
    }

    reduced_valid_roster = combined_valid_roster.slice(0, 13)
    valid_att_sums = reduced_valid_roster.map {|bot| bot.attributes_sum }
    duplicate_att_sum_bot = @fixture_team.bots.find do |bot|
      valid_att_sums.include?(bot.attributes_sum)
    end
    reduced_valid_roster.push(duplicate_att_sum_bot)
    param_invalid_att_sums = reduced_valid_roster.map.with_index  do |bot, i|
      {
        bot_id: bot.id,
        designation: i > 9 ? 'alternate' : 'starter'
      }
    end
    @invalid_att_sums = {
      players_attributes: param_invalid_att_sums
    }
  end

  test "roster with incorrect number of players is not created" do
    roster = @fixture_team.create_roster(@too_many_params)
    assert_equal false, roster.valid?
  end

  test "roster with invalid attribute sums is not created" do
    roster = @fixture_team.create_roster(@invalid_att_sums)
    assert_equal false, roster.valid?
  end
end
