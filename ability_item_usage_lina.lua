
deseo_lanzamiento_ulti = 0;
deseo_lanzamiento_segunda = 0;
deseo_lanzamiento_primera = 0;


-- funcion principal de uso de poderes
function AbilityUsageThink()

	local npcBot = GetBot();

	--print(npcBot:GetActiveMode())
	if ( npcBot:IsUsingAbility() ) then 
		return 
	end;
	
	habilidad_primera = npcBot:GetAbilityByName( "lina_dragon_slave" );
	habilidad_segunda = npcBot:GetAbilityByName( "lina_light_strike_array" );
	habilidad_ulti = npcBot:GetAbilityByName( "lina_laguna_blade" );
	
	deseo_lanzamiento_primera, objetivo_localizacion = Tratar_dragon_slave();
	deseo_lanzamiento_segunda, objetivo_localizacion_segunda = Tratar_Light_Strike_Array();
	deseo_lanzamiento_ulti, objetivo_ulti = Tratar_Laguna_Blade();

	if ( deseo_lanzamiento_ulti > deseo_lanzamiento_segunda and deseo_lanzamiento_ulti > deseo_lanzamiento_primera ) 
	then
		npcBot:Action_Chat("utilizo lina_laguna_blade(ULTI)",false);
		npcBot:Action_UseAbilityOnEntity( habilidad_ulti, objetivo_ulti );
		return;
	end	
	
	if ( deseo_lanzamiento_primera > 0 ) 
	then
		npcBot:Action_Chat("utilizo lina_dragon_slave(PRIMERA)",false);
		npcBot:Action_UseAbilityOnLocation( habilidad_primera, objetivo_localizacion );
		return;
	end
	
	if ( deseo_lanzamiento_segunda > 0 ) 
	then
		npcBot:Action_Chat("utilizo IMPACTO DE LUZ SOLAR(SEGUNDA)",false);
		npcBot:Action_UseAbilityOnLocation( habilidad_segunda, objetivo_localizacion_segunda );
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
		--p1 enemigos
		--p2 heroes
		--p3 localizacion central
		--p4 radio
		--p5 
		--p6 con una vida maxima
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, nDamage );

		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end




-- funcion segundo poder
function Tratar_Light_Strike_Array()

	local npcBot = GetBot();

	if ( not habilidad_segunda:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end;

	if ( deseo_lanzamiento_ulti > 0 ) 
	then
		return BOT_ACTION_DESIRE_NONE, 0;
	end


	local nRadius = habilidad_segunda:GetSpecialValueInt( "light_strike_array_aoe" );
	local nCastRange = habilidad_segunda:GetCastRange();
	local nDamage = habilidad_segunda:GetAbilityDamage();

	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_LANING 
		 ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, 0 );

		if ( locationAoE.count >= 3 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end






function CanCastLagunaBladeOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and npcTarget:IsHero() and ( GetBot():HasScepter() or not npcTarget:IsMagicImmune() ) and not npcTarget:IsInvulnerable();
end

function Tratar_Laguna_Blade()

	local npcBot = GetBot();

	
	if ( not habilidad_ulti:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local nCastRange = habilidad_ulti:GetCastRange();
	local nDamage = habilidad_primera:GetSpecialValueInt( "damage" );
	local eDamageType = npcBot:HasScepter() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL;

	local heroes_aliados_cerca = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #heroes_aliados_cerca >= 2 ) 
	then

		local objetivo = nil;
		local mayor_efecto = 0;
		local heroes_enemigos_cerca = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
		--itero enemigos para obtener el que tenga menos vida
		for _,npcEnemy in pairs( heroes_enemigos_cerca )
		do
			if ( CanCastLagunaBladeOnTarget( npcEnemy ) )
			then
				local nDamage = npcEnemy:GetEstimatedDamageToTarget( false, npcBot, 3.0, DAMAGE_TYPE_ALL );
				if ( nDamage > mayor_efecto )
				then
					mayor_efecto = nDamage;
					objetivo = npcEnemy;
				end
			end
		end

		if ( objetivo ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, objetivo;
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end


