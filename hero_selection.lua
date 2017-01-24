local counter = {
    ['npc_dota_hero_abaddon'] = 'npc_dota_hero_slark',
}

local function OtherTeam(team)
	if (team == TEAM_RADIANT) then
        return TEAM_DIRE
	else
		return TEAM_RADIANT
    end
end
----------------------------------------------------------------------------------------------------

function Think()
	local myTeamNo = GetTeam();
	local myTeam = GetTeamPlayers(myTeamNo);
    SelectHero(myTeam[1], 'npc_dota_hero_keeper_of_the_light');
    print('Keeper of the Light');
	local otherTeam = GetTeamPlayers(OtherTeam(myTeamNo));
	for i=2,5 do
		local name = GetSelectedHeroName(otherTeam[i]);
		if (name) then
            print(name .. '<-' .. counter[name]);
			SelectHero(myTeam[i], counter[name]);
        end
    end
end

function UpdateLaneAssignments()
    return {
        [1] = LANE_TOP,
        [2] = LANE_TOP,
        [3] = LANE_MID,
        [4] = LANE_BOT,
        [5] = LANE_BOT
    };
end

----------------------------------------------------------------------------------------------------
