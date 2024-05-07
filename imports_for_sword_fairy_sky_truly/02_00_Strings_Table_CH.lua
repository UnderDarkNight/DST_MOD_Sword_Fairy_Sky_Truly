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
           ["sword_fairy_com_map_jumper"] = {
                ["DEFAULT"] = "传送",
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
                ["inspect_str"] = "需要有魔法才能读这本书",
                ["recipe_desc"] = "百科全书",
           },
           ["sword_fairy_book_empty"] = {
                ["name"] = "《无字天书》",
                ["inspect_str"] = "需要有魔法才能读这本书，而且什么东西都没有",
                ["recipe_desc"] = "无字天书",
                ["spell_fail"] = "这本书没有什么变化",
                ["spell_succeed"] = "这本书没好像有了一点变化",
                ["next_day"] = "今天消耗太多了",
           },
        --------------------------------------------------------------------
        -- 04_foods
          ["sword_fairy_food_white_spirit"] = {
               ["name"] = "白酒",
               ["inspect_str"] = "白酒",
               ["oneat_desc"] = "白酒",
          },
          ["sword_fairy_food_fruit_liqor"] = {
               ["name"] = "果酒",
               ["inspect_str"] = "果酒",
               ["oneat_desc"] = "果酒",
          },
          ["sword_fairy_food_tincture"] = {
               ["name"] = "药酒",
               ["inspect_str"] = "药酒",
               ["oneat_desc"] = "药酒",
          },
          ["sword_fairy_food_sacred_wine"] = {
               ["name"] = "仙酒",
               ["inspect_str"] = "仙酒",
               ["oneat_desc"] = "仙酒",
          },
        --------------------------------------------------------------------
}

