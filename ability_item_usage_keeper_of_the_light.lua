function AbilityUsageThink()
    local npcBot = GetBot();

    local wave = npcBot:GetAbilityByName("keeper_of_the_light_illuminate");
    local stopWave = npcBot:GetAbilityByName("keeper_of_the_light_illuminate_end");

    local mana = npcBot:GetAbilityByName("keeper_of_the_light_chakra_magic");


    local creeps = npcBot:GetNearbyCreeps(1500, true)

    if wave:IsFullyCastable() and npcBot:GetMana() > mana:GetManaCost() and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if #creeps >= 3 then
            local neutralCreeps = 0;
            local castTarget;
            for _, creep in pairs(creeps) do
                if (creep ~= nil) then
                    if string.find(creep:GetUnitName(), 'neutral') then
                        neutralCreeps = neutralCreeps + 1;
                    else
                        castTarget = creep;
                    end
                end
            end
            if castTarget ~= nil and #creeps - neutralCreeps > 0 then
                print('WAVE!');
                return npcBot:Action_UseAbilityOnLocation(wave, castTarget:GetLocation());
            end
        end
    end


    if mana:IsFullyCastable() then
        local target = heroes_aliados_cercanos(npcBot, mana:GetCastRange());
        if target ~= nil then
            print('MANA!');
            return npcBot:Action_UseAbilityOnEntity(mana, target);
        end
    end
end


function heroes_aliados_cercanos(npcBot, rango)

    local heroes = npcBot:GetNearbyHeroes(rango, false, BOT_MODE_ATTACK);

    local value = npcBot['GetMana'](npcBot);

    if #heroes == 0 then
        return nil, 0;
    end
    print(#heroes)
    if heroes == nil or #heroes == 1 then
        return npcBot, value;
    end

    local hero;
    for _, h in pairs(heroes) do

        if h ~= nil and h:IsAlive() then

            local valueToCompare = h['GetMana'](h);

            if valueToCompare < value then
                value = valueToCompare;
                hero = h;
            end
        end
    end

    return hero, value;
end