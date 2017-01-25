castLBDesire = 0;
castLSADesire = 0;
deseo_lanzamiento_primera = 0;


-- funcion principal de uso de poderes
function AbilityUsageThink()

	local npcBot = GetBot();

	print(npcBot:GetActiveMode())
	if ( npcBot:IsUsingAbility() ) then 
		return 
	end;
	
	habilidad_primera = npcBot:GetAbilityByName( "lina_dragon_slave" );
	
	deseo_lanzamiento_primera, objetivo_localizacion = Tratar_dragon_slave();
	
	if ( deseo_lanzamiento_primera > 0 ) 
	then
		npcBot:Action_Chat("utilizo lina_dragon_slave(PRIMERA)",false);
		npcBot:Action_UseAbilityOnLocation( habilidad_primera, objetivo_localizacion );
		return;
	end
	
end

function Tratar_dragon_slave()

	local npcBot = GetBot();

	if ( not habilidad_primera:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end;
	
	local nRadius = habilidad_primera:GetSpecialValueInt( "dragon_slave_width_end" );
	local nCastRange = habilidad_primera:GetCastRange();
	local nDamage = habilidad_primera:GetAbilityDamage();

	-- matar mas de 3 crips con el primer poder
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, nDamage );

		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_LANING 
		 ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, nDamage );

		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end