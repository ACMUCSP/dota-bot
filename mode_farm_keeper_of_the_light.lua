local lastTimeHit = 0;

local function SearchWeakestCreep(creeps, worstLife)
    local attackCreep;
    for _, creep in pairs(creeps) do
        if (creep ~= nil) then
            local per = creep:GetHealth() / creep:GetMaxHealth();
            if (per < worstLife) then
                worstLife = per;
                attackCreep = creep;
            end
        end
    end

    return attackCreep;
end

function OnStart()
    local bot = GetBot();
    bot:Action_Chat('Farming!', false);
end

function Think()
    if DotaTime() < lastTimeHit + 1 then
        return;
    end

    local bot = GetBot();
    local creeps = bot:GetNearbyCreeps(1500, true);
    local weakest = SearchWeakestCreep(creeps, 0.5)
    if weakest ~= nil then
        bot:Action_AttackUnit(weakest, false);
        print(bot:GetPlayerID() .. ' Creeping');
        lastTimeHit = DotaTime();
        return;
    end

    creeps = bot:GetNearbyCreeps(1500, false);
    weakest = SearchWeakestCreep(creeps, 0.2)
    if weakest ~= nil then
        bot:Action_AttackUnit(weakest, false);
        print(bot:GetPlayerID() .. 'Denying');
        lastTimeHit = DotaTime();
    end
end

function GetDesire()
    local bot = GetBot();
    if SearchWeakestCreep(bot:GetNearbyCreeps(1500, true), 0.5) ~= nil or
            SearchWeakestCreep(bot:GetNearbyCreeps(1500, false), 0.2) ~= nil then
        return 1;
    end
    return 0;
end
