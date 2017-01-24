local DEFAULT_HERO = 'npc_dota_hero_keeper_of_the_light';

local counter = {
    ['npc_dota_hero_abaddon'] = 'npc_dota_hero_axe',
    ['npc_dota_hero_alchemist'] = 'npc_dota_hero_clinkz',
    ['npc_dota_hero_ancient_apparition'] = 'npc_dota_hero_venomancer',
    ['npc_dota_hero_ancient_antimage'] = 'npc_dota_hero_riki',
    ['npc_dota_hero_axe'] = 'npc_dota_hero_necrolyte',
    ['npc_dota_hero_bane'] = 'npc_dota_hero_necrolyte',
    ['npc_dota_hero_batrider'] = 'npc_dota_hero_disruption',
    ['npc_dota_hero_beastmaster'] = 'npc_dota_hero_death_prophet',
    ['npc_dota_hero_bloodseeker'] = 'npc_dota_hero_lone_druid',
    ['npc_dota_hero_bounty_hunter'] = 'npc_dota_hero_riki',
    ['npc_dota_hero_bristleback'] = 'npc_dota_hero_legion_commander',
    ['npc_dota_hero_broodmother'] = 'npc_dota_hero_axe',
    ['npc_dota_hero_centaur'] = 'npc_dota_hero_life_stealer',
    ['npc_dota_hero_chaos_knight'] = 'npc_dota_hero_necrolyte',
    ['npc_dota_hero_chen'] = 'npc_dota_hero_ancient_apparition',
    ['npc_dota_hero_crystal_maiden'] = 'npc_dota_hero_ogre_magi',
    ['npc_dota_hero_dragon_knight'] = 'npc_dota_hero_life_stealer',
    ['npc_dota_hero_drow_ranger'] = 'npc_dota_hero_nyx_assassin',
    ['npc_dota_hero_earthshaker'] = 'npc_dota_hero_zuus',
    ['npc_dota_hero_enigma'] = 'npc_dota_hero_silencer',
    ['npc_dota_hero_faceless_void'] = 'npc_dota_hero_omniknight',
    ['npc_dota_hero_gyrocopter'] = 'npc_dota_hero_clinkz',
    ['npc_dota_hero_huzkar'] = 'npc_dota_hero_antimage',
    ['npc_dota_hero_invoker'] = 'npc_dota_hero_wisp',
    ['npc_dota_hero_wisp'] = 'npc_dota_hero_spirit_breaker',
    ['npc_dota_hero_jakiro'] = 'npc_dota_hero_undying',
    ['npc_dota_hero_juggernaut'] = 'npc_dota_hero_shadow_shaman',
    ['npc_dota_hero_keeper_of_the_light'] = 'npc_dota_hero_naga_siren',
    ['npc_dota_hero_kunkka'] = 'npc_dota_hero_undying',
    ['npc_dota_hero_legion_commander'] = 'npc_dota_hero_abaddon',
    ['npc_dota_hero_leshrac'] = 'npc_dota_hero_pugna',
    ['npc_dota_hero_lich'] = 'npc_dota_hero_tiny',
    ['npc_dota_hero_medusa'] = 'npc_dota_hero_antimage',
    ['npc_dota_hero_slark'] = 'npc_dota_hero_ancient_apparition',
    ['npc_dota_hero_troll_warlord'] = 'npc_dota_hero_bloodseeker',
    ['npc_dota_hero_mirana'] = 'npc_dota_hero_riki',
    ['npc_dota_hero_riki'] = 'npc_dota_hero_spirit_breaker',
    ['npc_dota_hero_ursa'] = 'npc_dota_hero_broodmother',
    ['npc_dota_hero_viper'] = 'npc_dota_hero_antimage',
    ['npc_dota_hero_weaver'] = 'npc_dota_hero_crystal_maiden',
    ['npc_dota_hero_slardar'] = 'npc_dota_hero_riki',
    ['npc_dota_hero_clinkz'] = 'npc_dota_hero_spirit_breaker',
    ['npc_dota_hero_templar_assassin'] = 'npc_dota_hero_gyrocopter',
    ['npc_dota_hero_phantom_assassin'] = 'npc_dota_hero_obsidian_destroyer',
    ['npc_dota_hero_sven'] = 'npc_dota_hero_batrider',
    ['npc_dota_hero_magnataur'] = 'npc_dota_hero_faceless_void',
    ['npc_dota_hero_lion'] = 'npc_dota_hero_undying',
    ['npc_dota_hero_puck'] = 'npc_dota_hero_silencer',
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
	local otherTeam = GetTeamPlayers(OtherTeam(myTeamNo));

    SelectHero(myTeam[1], DEFAULT_HERO);

	for i=2,5 do
		local name = GetSelectedHeroName(otherTeam[i]);
		if (name ~= '') then
            local counter_name = counter[name];
            if (counter_name == nil) then
                counter_name = DEFAULT_HERO;
            end
			SelectHero(myTeam[i], counter_name);
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
