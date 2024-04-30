------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    角色基础初始化

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function Language_check()
    local language = "en"
    if type(TUNING["sword_fairy_sky_truly.Language"]) == "function" then
        language = TUNING["sword_fairy_sky_truly.Language"]()
    elseif type(TUNING["sword_fairy_sky_truly.Language"]) == "string" then
        language = TUNING["sword_fairy_sky_truly.Language"]
    end
    return language
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色立绘大图
    GLOBAL.PREFAB_SKINS["sword_fairy_sky_truly"] = {
        "sword_fairy_sky_truly_none",
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色选择时候都文本
    if Language_check() == "ch" then
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["sword_fairy_sky_truly"] = "剑仙·天真"
        STRINGS.CHARACTER_NAMES["sword_fairy_sky_truly"] = "天真"
        STRINGS.CHARACTER_DESCRIPTIONS["sword_fairy_sky_truly"] = "剑仙·天真"
        STRINGS.CHARACTER_QUOTES["sword_fairy_sky_truly"] = "仗剑走天涯"

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("sword_fairy_sky_truly")] = require "speech_sword_fairy_sky_truly"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("sword_fairy_sky_truly")] = "天真"
        STRINGS.SKIN_NAMES["sword_fairy_sky_truly_none"] = "天真"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["sword_fairy_sky_truly"] = "特别容易"
    else
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["sword_fairy_sky_truly"] = "Sword Fairy SkyTruly"
        STRINGS.CHARACTER_NAMES["sword_fairy_sky_truly"] = "SkyTruly"
        STRINGS.CHARACTER_DESCRIPTIONS["sword_fairy_sky_truly"] = "Sword Fairy"
        STRINGS.CHARACTER_QUOTES["sword_fairy_sky_truly"] = "fight with the sword at the end of the world"

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("sword_fairy_sky_truly")] = require "speech_sword_fairy_sky_truly"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("sword_fairy_sky_truly")] = "SkyTruly"
        STRINGS.SKIN_NAMES["sword_fairy_sky_truly_none"] = "SkyTruly"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["sword_fairy_sky_truly"] = "easy"

    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------增加人物到mod人物列表的里面 性别为女性（ MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
    AddModCharacter("sword_fairy_sky_truly", "FEMALE")

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面人物三维显示
    TUNING[string.upper("sword_fairy_sky_truly").."_HEALTH"] = 70
    TUNING[string.upper("sword_fairy_sky_truly").."_HUNGER"] = 350
    TUNING[string.upper("sword_fairy_sky_truly").."_SANITY"] = 70
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面初始物品显示，物品相关的prefab
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper("sword_fairy_sky_truly")] = {"log"}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
