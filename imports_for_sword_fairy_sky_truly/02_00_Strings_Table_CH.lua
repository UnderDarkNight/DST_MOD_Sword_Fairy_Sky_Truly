if TUNING["sword_fairy_sky_truly.Strings"] == nil then
    TUNING["sword_fairy_sky_truly.Strings"] = {}
end

local this_language = "ch"
-- if TUNING["sword_fairy_sky_truly.Language"] then
--     if type(TUNING["sword_fairy_sky_truly.Language"]) == "function" and TUNING["sword_fairy_sky_truly.Language"]() ~= this_language then
--         return
--     elseif type(TUNING["sword_fairy_sky_truly.Language"]) == "string" and TUNING["sword_fairy_sky_truly.Language"] ~= this_language then
--         return
--     end
-- end

--------- 默认加载中文文本，如果其他语言的文本缺失，直接调取 中文文本。 03_TUNING_Common_Func.lua
--------------------------------------------------------------------------------------------------
--- 默认显示名字:  name
--- 默认显示描述:  inspect_str
--- 默认制作栏描述: recipe_desc
--------------------------------------------------------------------------------------------------
TUNING["sword_fairy_sky_truly.Strings"][this_language] = TUNING["sword_fairy_sky_truly.Strings"][this_language] or {
        --------------------------------------------------------------------
        --- 正在debug 测试的
            ["sword_fairy_sky_truly_skin_test_item"] = {
                ["name"] = "皮肤测试物品",
                ["inspect_str"] = "inspect单纯的测试皮肤",
                ["recipe_desc"] = "测试描述666",
            },
        --------------------------------------------------------------------
        --- 组件动作
           ["sword_fairy_com_food_refuser"] = {
                ["default"] = "不醉不欢",
                ["spoiled"] = "都开始发臭了",
           },
        --------------------------------------------------------------------
        -- 00_others
           ["sword_fairy_other_drunkenness_damage"] = {
                ["name"] = "嗜酒如命",
           },
        --------------------------------------------------------------------
        -- 02_items
           ["sword_fairy_weapon_flying_sword"] = {
                ["name"] = "飞剑",
                ["inspect_str"] = "独属于剑仙的飞剑",
                ["recipe_desc"] = "独属于剑仙的飞剑",
           },
           ["sword_fairy_book_encyclopedia"] = {
                ["name"] = "《百科全书》",
                ["inspect_str"] = "百科全书",
                ["recipe_desc"] = "百科全书",
           },
        --------------------------------------------------------------------
}

