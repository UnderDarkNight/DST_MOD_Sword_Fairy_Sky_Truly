--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【不吃有怪物度的或者发黄食物（不新鲜的），吃食材收益减半的特质】
    饱食度消耗为1.5倍威尔逊 


    health_delta, hunger_delta, sanity_delta = self.custom_stats_mod_fn(self.inst, health_delta, hunger_delta, sanity_delta, food, feeder)

    

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function GetStringsTable(prefab_name)
        local temp_name = "sword_fairy_com_food_refuser"
        return TUNING["sword_fairy_sky_truly.fn"].GetStringsTable(temp_name or prefab_name)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    -------------------------------------------------------------------------------------------------
    --- 专属食物拒绝器，用来配合醉意值。醉意值小于等于1点，人物拒绝吃饭
        inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_food_refuser",function(inst,replica_com)
            replica_com.IsRefuse = function(self,food)
                if food and food:HasOneOfTags({"spoiled","stale"}) then
                    return true
                end
                local drunkenness_com = inst.replica.sword_fairy_com_drunkenness or inst.replica._.sword_fairy_com_drunkenness
                if drunkenness_com and drunkenness_com:GetCurrent() <= 1 then
                    return true
                end
                return false
            end
        end)
        if TheWorld.ismastersim then            
            inst:AddComponent("sword_fairy_com_food_refuser")
            inst.components.sword_fairy_com_food_refuser:SetDefaultRefuseReason( GetStringsTable()["default"] or "不醉不欢")
            inst.components.sword_fairy_com_food_refuser:SetRefuseReasonFn(function(food)
                if food and food:HasOneOfTags({"spoiled","stale"}) then
                    return GetStringsTable()["spoiled"] or "都开始发臭了"
                end
            end)
        end
    -------------------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return
    end
    ---- 通用事件安装
    inst:ListenForEvent("master_postinit_sword_fairy_sky_truly",function()
        
        ----- 饱食度消耗为1.5倍威尔逊,战斗时饥饿消耗速率为3倍。
            local base_hungerrate = 1.5 * TUNING.WILSON_HUNGER_RATE
            inst.components.hunger.hungerrate = base_hungerrate

        ----- 不食用发黄食物（不新鲜的）。
            -- inst.components.eater:SetRefusesSpoiledFood(true)
            local old_TestFood = inst.components.eater.TestFood
            inst.components.eater.TestFood = function(self,food, testvalues)
                if food and food:HasOneOfTags({"spoiled","stale"}) then
                    return false
                end
                return old_TestFood(self,food, testvalues)
            end
            

        ----- 人物无法从食物中获取理智值和血量，转而全部改为饱食度。而且收益减半。
            inst.components.eater.custom_stats_mod_fn = function(self, health_delta, hunger_delta, sanity_delta, food, feeder)
                if hunger_delta < 0 then
                    hunger_delta = 0
                end
                if sanity_delta > 0 then
                    hunger_delta = hunger_delta + sanity_delta
                    sanity_delta = 0
                end
                if health_delta > 0 then
                    hunger_delta = hunger_delta + health_delta
                    health_delta = 0
                end
                if hunger_delta > 0 then
                    hunger_delta = hunger_delta * 0.5
                end
                return health_delta, hunger_delta, sanity_delta
            end
        ----- 战斗3倍 饥饿消耗
            inst:ListenForEvent("sword_fairy_event.danger_music_start",function()
                inst.components.hunger.hungerrate = 3 * base_hungerrate
                if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                    TheNet:Announce("战斗开始，饥饿消耗加倍")
                end
            end)
            inst:ListenForEvent("sword_fairy_event.danger_music_stop",function()
                inst.components.hunger.hungerrate = base_hungerrate
                if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                    TheNet:Announce("战斗结束")
                end
            end)
    end)

    -----------------------------------------------------------------------------------------------------------------------------
    ---- 【盛宴】【食用不同料理】【饱食度上限增加2点，饥饿速率增加1%】
        ------------------------------------------------------------------------------------------------------------------
        ---- 基础API
            local function RememberFood(food_prefab)
                local remember_list = inst.components.sword_fairy_com_data:Get("food_remenber_index") or {}
                remember_list[food_prefab] = true
                inst.components.sword_fairy_com_data:Set("food_remenber_index",remember_list)            
            end
            local function GetRememberedFoodsNum()
                local remember_list = inst.components.sword_fairy_com_data:Get("food_remenber_index") or {}
                local food_num = 0
                for k,v in pairs(remember_list) do
                    food_num = food_num + 1
                end
                return food_num
            end
            local function upgrade_max_hunger()
                local get_food_num = GetRememberedFoodsNum()
                print("fake error get_food_num",get_food_num)
                local base_max_hunger = TUNING[string.upper("sword_fairy_sky_truly").."_HUNGER"]
                inst.components.hunger.max = base_max_hunger + 2 * get_food_num
                -- inst.components.health:ForceUpdateHUD(true)
                inst.components.hunger.burnratemodifiers:SetModifier( inst , 1 + 0.01*get_food_num ) --- 饱食度速率增加1%
            end
        ------------------------------------------------------------------------------------------------------------------
        ---- 数据读取/记录
            inst.components.sword_fairy_com_data:AddOnLoadFn(function()
                upgrade_max_hunger()
                local saved_curren_hunger = inst.components.sword_fairy_com_data:Get("current_hunger")
                if saved_curren_hunger then
                    inst.components.hunger.current = saved_curren_hunger
                end
                inst.components.sword_fairy_com_data:Set("current_hunger",nil)
            end)
            inst.components.sword_fairy_com_data:AddOnSaveFn(function()
                local current_hunger = inst.components.hunger.current
                inst.components.sword_fairy_com_data:Set("current_hunger",current_hunger)
            end)
        ------------------------------------------------------------------------------------------------------------------
        ---- 吃东西的 event
            inst:ListenForEvent("oneat",function(inst,_table)
                local food = _table and _table.food or {}
                if not ( food.HasTag and food:HasTag("preparedfood") and food.prefab ) then
                    return
                end
                print("+++++ info ",food)
                RememberFood(food.prefab)
                upgrade_max_hunger()
            end)
        ------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------

end