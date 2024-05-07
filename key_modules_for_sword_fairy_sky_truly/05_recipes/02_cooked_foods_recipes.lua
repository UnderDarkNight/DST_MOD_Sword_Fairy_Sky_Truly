
---------------------------------------------------------------------------------------------------------------------
--- 文本表获取
    local function GetStringsTable(prefab_name)
        local temp_name = nil
        return TUNING["sword_fairy_sky_truly.fn"].GetStringsTable(temp_name or prefab_name)
    end
---------------------------------------------------------------------------------------------------------------------
--- 设置可以放烹饪锅里
    local cooking = require("cooking")
    local ingredients = cooking.ingredients
    -----------------------------------------------------------------------
    --- 火荨麻
        if ingredients["firenettles"] then

        else
            AddIngredientValues({"firenettles"}, {
                veggie = 1,
            })
        end
    -----------------------------------------------------------------------
    --- 猪皮
        if ingredients["pigskin"] then

        else
            AddIngredientValues({"pigskin"}, {
                pigskin = 1,
                inedible = 1,
            })
        end
    -----------------------------------------------------------------------
    --- 熊皮
        if ingredients["bearger_fur"] then

        else
            AddIngredientValues({"bearger_fur"}, {
                bearger_fur = 1,
                inedible = 1,
            })
        end
    -----------------------------------------------------------------------
    --- 独眼巨鹿眼球
        if ingredients["deerclops_eyeball"] then

        else
            AddIngredientValues({"deerclops_eyeball"}, {
                deerclops_eyeball = 1,
                inedible = 1,
            })
        end
    -----------------------------------------------------------------------
    --- 守护者之角
        if ingredients["minotaurhorn"] then

        else
            AddIngredientValues({"minotaurhorn"}, {
                minotaurhorn = 1,
                inedible = 1,
            })
        end
    -----------------------------------------------------------------------
    --- 蘑菇皮
        if ingredients["shroom_skin"] then

        else
            AddIngredientValues({"shroom_skin"}, {
                shroom_skin = 1,
                inedible = 1,
            })
        end
    -----------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
----- 白酒
    local sword_fairy_food_white_spirit = {
        test = function(cooker, names, tags)
            return (names.corn or 0) == 1  and ( names.ice or 0) == 2 and ( names.firenettles or 0) == 1 
        end,
        name = "sword_fairy_food_white_spirit", -- 料理名
        weight = 100, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是素食
        hunger = 0 , --吃后回饥饿值
        sanity = 1 , --吃后回精神值
        health = 1 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "sword_fairy_food_white_spirit.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/sword_fairy_food_white_spirit.xml",  
        overridebuild = "sword_fairy_food_white_spirit",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("sword_fairy_food_white_spirit")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", sword_fairy_food_white_spirit) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", sword_fairy_food_white_spirit) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------
----- 果酒
    local sword_fairy_food_fruit_liqor = {
        test = function(cooker, names, tags)
            return ( names.firenettles or 0) == 1 and (tags.fruit or 0) >= 1
                and (tags.meat or 0) == 0 and (tags.fish or 0) == 0 and (tags.egg or 0) == 0 and (tags.inedible or 0) == 0
        end,
        name = "sword_fairy_food_fruit_liqor", -- 料理名
        weight = 100, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是素食
        hunger = 0 , --吃后回饥饿值
        sanity = 1 , --吃后回精神值
        health = 1 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "sword_fairy_food_fruit_liqor.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/sword_fairy_food_fruit_liqor.xml",  
        overridebuild = "sword_fairy_food_fruit_liqor",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("sword_fairy_food_fruit_liqor")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", sword_fairy_food_fruit_liqor) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", sword_fairy_food_fruit_liqor) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------
----- 药酒
    local sword_fairy_food_tincture = {
        test = function(cooker, names, tags)
            return ( names.firenettles or 0) == 1 and (names.ice or 0) == 2 and (
                (names.pigskin or 0) == 1
            )
        end,
        name = "sword_fairy_food_tincture", -- 料理名
        weight = 100, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是素食
        hunger = 0 , --吃后回饥饿值
        sanity = 1 , --吃后回精神值
        health = 1 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "sword_fairy_food_tincture.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/sword_fairy_food_tincture.xml",  
        overridebuild = "sword_fairy_food_tincture",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("sword_fairy_food_tincture")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", sword_fairy_food_tincture) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", sword_fairy_food_tincture) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------
----- 仙酒
    local sword_fairy_food_sacred_wine = {
        test = function(cooker, names, tags)
            return ( names.firenettles or 0) == 1 and (names.ice or 0) == 2 and (
                (names.mandrake or 0) + (names.bearger_fur or 0) + (names.deerclops_eyeball or 0) + (names.minotaurhorn or 0) + (names.shroom_skin or 0) == 1
            )
        end,
        name = "sword_fairy_food_sacred_wine", -- 料理名
        weight = 100, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是素食
        hunger = 0 , --吃后回饥饿值
        sanity = 1 , --吃后回精神值
        health = 1 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "sword_fairy_food_sacred_wine.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/sword_fairy_food_sacred_wine.xml",  
        overridebuild = "sword_fairy_food_sacred_wine",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("sword_fairy_food_sacred_wine")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", sword_fairy_food_sacred_wine) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", sword_fairy_food_sacred_wine) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------
