if TUNING["sword_fairy_sky_truly.Strings"] == nil then
    TUNING["sword_fairy_sky_truly.Strings"] = {}
end

local this_language = "en"
if TUNING["sword_fairy_sky_truly.Language"] then
    if type(TUNING["sword_fairy_sky_truly.Language"]) == "function" and TUNING["sword_fairy_sky_truly.Language"]() ~= this_language then
        return
    elseif type(TUNING["sword_fairy_sky_truly.Language"]) == "string" and TUNING["sword_fairy_sky_truly.Language"] ~= this_language then
        return
    end
end

TUNING["sword_fairy_sky_truly.Strings"][this_language] = TUNING["sword_fairy_sky_truly.Strings"][this_language] or {
        --------------------------------------------------------------------
        --- 正在debug 测试的
            -- ["sword_fairy_sky_truly_skin_test_item"] = {
            --     ["name"] = "en皮肤测试物品",
            --     ["inspect_str"] = "en inspect单纯的测试皮肤",
            --     ["recipe_desc"] = " en 测试描述666",
            -- },        
        --------------------------------------------------------------------
        --- 组件动作
            ["sword_fairy_com_food_refuser"] = {
                ["default"] = "not get drunk or happy",
                ["spoiled"] = "It's starting to stink",
            },
            ["sword_fairy_com_map_jumper"] = {
                ["DEFAULT"] = "Teleport",
           },
        --------------------------------------------------------------------
        -- 00_others
            ["sword_fairy_other_drunkenness_damage"] = {
                ["name"] = "love wine as one's life (idiom); fond of the bottle",
            },
        --------------------------------------------------------------------
        -- 02_items
            ["sword_fairy_weapon_flying_sword"] = {
                ["name"] = "Flying Sword",
                ["inspect_str"] = "It's the only flying sword that belongs to a Sword Fairy.",
                ["recipe_desc"] = "It's the only flying sword that belongs to a Sword Fairy.",
            },
            ["sword_fairy_book_encyclopedia"] = {
                ["name"] = "Encyclopedia",
                ["inspect_str"] = "It takes magic to read this book.",
                ["recipe_desc"] = "Encyclopedia",
             },
           ["sword_fairy_book_empty"] = {
                ["name"] = "Blank Book",
                ["inspect_str"] = "A book with nothing in it.",
                ["recipe_desc"] = "Blank Book",
                ["spell_fail"] = "Nothing has changed in this book.",
                ["spell_succeed"] = "The book hasn't changed a bit.",
                ["next_day"] = "I've consumed too much today.",
            },
        --------------------------------------------------------------------
        -- 04_foods
            ["sword_fairy_food_white_spirit"] = {
                ["name"] = "White Spirit",
                ["inspect_str"] = "White Spirit",
                ["oneat_desc"] = "White Spirit",
            },
            ["sword_fairy_food_fruit_liqor"] = {
                ["name"] = "Fruit Liqor",
                ["inspect_str"] = "Fruit Liqor",
                ["oneat_desc"] = "Fruit Liqor",
            },
            ["sword_fairy_food_tincture"] = {
                ["name"] = "Tincture",
                ["inspect_str"] = "Tincture",
                ["oneat_desc"] = "Tincture",
           },
           ["sword_fairy_food_sacred_wine"] = {
                ["name"] = "Sacred Wine",
                ["inspect_str"] = "Sacred Wine",
                ["oneat_desc"] = "Sacred Wine",
           },
        --------------------------------------------------------------------

}