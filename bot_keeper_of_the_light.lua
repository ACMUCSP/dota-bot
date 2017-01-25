local positions = {Vector(0, 0), Vector(2000, 0), Vector(2000, 2000), Vector(0, 2000)};
local pos_id = 1;
local set = false;


function Think()
    local bot = GetBot();
    if (not bot:IsAlive()) then
        return;
    end

    if (not set) then
        local location = bot:GetLocation();
        print('setting locations');
        for i=1,4 do
            positions[i] = location + positions[i];
        end
        set = true;
        return;
    end

    if (DotaTime() < -88) then
        return;
    end

    if (GetUnitToLocationDistance(bot, positions[pos_id]) < 200) then
        print('moving!');
        pos_id = pos_id + 1;
        if (pos_id > 4) then
            pos_id = 1;
        end
        bot:Action_MoveToLocation(positions[pos_id]);
    end
end