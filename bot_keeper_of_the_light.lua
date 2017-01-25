local positions = {
    Vector(-104, -6244), Vector(4930, -6142),
    Vector(-6195, 1787), Vector(-6143, -860),
    Vector(-3540, -2791), Vector(-1660, -1516)
};
local pos_id = 0;


function Think()
    local bot = GetBot();
    if (not bot:IsAlive() or DotaTime() < -88) then
        return;
    end

    if (pos_id == 0) then
        pos_id = 1;
        bot:Action_MoveToLocation(positions[pos_id]);
    end

    if (GetUnitToLocationDistance(bot, positions[pos_id]) < 200) then
        pos_id = pos_id + 1;
        if (pos_id > #positions) then
            pos_id = 1;
        end
        bot:Action_MoveToLocation(positions[pos_id]);
    end
end