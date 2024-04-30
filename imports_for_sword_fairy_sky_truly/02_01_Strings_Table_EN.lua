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
        --------------------------------------------------------------------
        -- 00_others
                ["sword_fairy_other_drunkenness_damage"] = {
                    ["name"] = "love wine as one's life (idiom); fond of the bottle",
               }
        --------------------------------------------------------------------

}