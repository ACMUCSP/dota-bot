local tableItemsToBuy = {
    "item_flask",
    "item_circlet",
    "item_mantle",

    "item_boots",
    "item_blades_of_attack",
    "item_blades_of_attack",

    "item_recipe_null_talisman",

    "item_belt_of_strength",
    "item_staff_of_wizardry",
    "item_recipe_necronomicon",
    "item_recipe_necronomicon",
    "item_recipe_necronomicon",

    "item_staff_of_wizardry",
    "item_recipe_dagon",

    "item_recipe_dagon",
    "item_recipe_dagon",
    "item_recipe_dagon",
    "item_recipe_dagon",

    "item_platemail",
    "item_mystic_staff",
    "item_recipe_shivas_guard",

    "item_shadow_amulet",
    "item_claymore",
    "item_ultimate_orb",
    "item_recipe_silver_edge"
};
----------------------------------------------------------------------------------------------------
function ItemPurchaseThink()
    local npcBot = GetBot();

    -- no hay items para comprar
    if (#tableItemsToBuy == 0) then
        npcBot:SetNextItemPurchaseValue(0);
        return;
    end

    local siguiente_item = tableItemsToBuy[1];


    npcBot:SetNextItemPurchaseValue(GetItemCost(siguiente_item));

    if (npcBot:GetGold() >= GetItemCost(siguiente_item)) then
        npcBot:Action_Chat("compro: " .. siguiente_item, false);
        npcBot:Action_PurchaseItem(siguiente_item);
        table.remove(tableItemsToBuy, 1);
    end
end

----------------------------------------------------------------------------------------------------
