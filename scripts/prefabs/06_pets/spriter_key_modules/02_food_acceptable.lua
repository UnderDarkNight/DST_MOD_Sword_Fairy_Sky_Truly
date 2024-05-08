--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 
    local function GetStringsTable(prefab_name)
        local temp_name = "sword_fairy_spriter"
        return TUNING["sword_fairy_sky_truly.fn"].GetStringsTable(temp_name or prefab_name)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 外部参数表加载,独立的lua切割
    local food_param = require("prefabs/06_pets/spriter_key_modules/03_food_param") or {}
---- 食物和回复值列表列表
    local food_prefab_list_with_mp =  food_param.food_prefab_list_with_mp or  {}
---- 食物偷吃列表
    local pilfer_food = food_param.pilfer_food or  {}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 食物类别    
    -----------------------------------------------------------------------------
    ---- 食物类别
        local food_tags = {}
        for _, temp_data in pairs(FOODGROUP) do
            temp_data.types = temp_data.types or {}
            for _, temp_food_type in pairs(temp_data.types) do
                food_tags[temp_food_type] = true
            end
        end
        for food_type, v in pairs(food_tags) do
            table.insert(food_tags, "edible_"..food_type)
        end
    -----------------------------------------------------------------------------
    ---- API
        local function CheckIsFood(food_inst)
            if food_inst:HasOneOfTags(food_tags) then
                return true
            end
            if food_prefab_list_with_mp[food_inst.prefab] then
                return true
            end
            return false
        end
    -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 食物记忆组件
    local THE_SAME_FOOD_DAY = TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 0 or 3
    local function CheckCanEat(inst,food_inst)
        local food_remember_data = inst.components.sword_fairy_com_data:Get("food_remember_data") or {}
        if food_remember_data[food_inst.prefab] == nil then
            return true
        end
        if TheWorld.state.cycles - food_remember_data[food_inst.prefab] >= THE_SAME_FOOD_DAY then
            return true
        end
        return false
    end
    local function FoodRemember(inst,food_inst)
        local food_remember_data = inst.components.sword_fairy_com_data:Get("food_remember_data") or {}
        food_remember_data[food_inst.prefab] = TheWorld.state.cycles
        inst.components.sword_fairy_com_data:Set("food_remember_data",food_remember_data)
    end
    local function GetRememerFoodsNum(inst)
        local food_remember_data = inst.components.sword_fairy_com_data:Get("food_remember_data") or {}
        local food_num = 0
        for k,v in pairs(food_remember_data) do
            if k and v then
                food_num = food_num + 1
            end
        end
        return food_num
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 吃东西回蓝event
        if TheWorld.ismastersim then
            inst:ListenForEvent("eat_food",function(inst,_table)
                -- _table = _table or {
                --     food = item,
                --     remember = true
                -- }
                
                local food = _table.food
                local remember = _table.remember or false
                local food_prefab = food.prefab
                local mp_delta = food_prefab_list_with_mp[food_prefab] or 0
                
                inst.components.sword_fairy_com_magic_point_sys:DoDelta(mp_delta)
                
                if remember then
                    FoodRemember(inst,food)
                end
                if food.components.stackable then
                    food.components.stackable:Get():Remove()
                else
                    food:Remove()
                end
            end)
        end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 物品接受组件
        inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_acceptable",function(inst,replica_com)
            replica_com:SetSGAction("give")
            replica_com:SetText("sword_fairy_spriter",STRINGS.ACTIONS.FEED)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if not right_click then
                    return false
                end
                if doer ~= inst:GetLinkedPlayer() then
                    return false
                end
                return CheckIsFood(item)
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("sword_fairy_com_acceptable")
            inst.components.sword_fairy_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                if not CheckIsFood(item) then
                    return false
                end
                if not CheckCanEat(inst,item) then
                    inst:PushEvent("say_refuse_food")
                    print("info CheckCanEat  false")
                    return false
                end  
                ---------------------------------------------------------
                --- 
                ---------------------------------------------------------
                ---
                    local mp_delta = 0
                    if food_prefab_list_with_mp[item.prefab] then
                        mp_delta = food_prefab_list_with_mp[item.prefab]
                    end
                ---------------------------------------------------------
                --- 记忆并移除物品
                    FoodRemember(inst,item)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                ---------------------------------------------------------
                --- 先修复上限，再回蓝
                    inst:PushEvent("MP_MAX_VALUE_INIT")
                    inst.components.sword_fairy_com_magic_point_sys:DoDelta(mp_delta)
                ---------------------------------------------------------
                --- 偷吃标记位
                    inst.components.sword_fairy_com_data:Set("need_2_stole_food_day_flag",TheWorld.state.cycles)
                ---------------------------------------------------------
                return true
            end)
        end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- MP_MAX_VALUE_INIT
        if TheWorld.ismastersim then
            inst:ListenForEvent("MP_MAX_VALUE_INIT",function()                
                local remember_foods = GetRememerFoodsNum(inst)
                local mp_base_max = inst.components.sword_fairy_com_magic_point_sys.base_max or 7                 
                inst.components.sword_fairy_com_magic_point_sys.max = math.clamp(mp_base_max + remember_foods,mp_base_max,7000)
            end)
        end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 偷吃处理
        if TheWorld.ismastersim then

            local function do_pilfer_food()
                ----------------------------------------------------------------------------------------
                --- 先偷吃最喜欢的
                    local foods_in_slot = {}
                    inst.components.container:ForEachItem(function(item)
                        if item and item.prefab and item:IsValid() and pilfer_food[item.prefab] then
                            table.insert(foods_in_slot,item)
                        end
                    end)
                    if #foods_in_slot > 0 then
                        local tar_food = foods_in_slot[math.random(1,#foods_in_slot)]
                        inst:PushEvent("eat_food",{
                            food = tar_food,
                            remember = false
                        })
                        return true
                    end                    
                ----------------------------------------------------------------------------------------
                --- 没有最喜欢的时候，寻找能吃的
                    for index, item in pairs(inst.components.container.slots) do
                        if item and item.prefab and item:IsValid() and CheckIsFood(item) then
                            inst:PushEvent("eat_food",{
                                food = item,
                                remember = true
                            })
                            return true
                        end
                    end
                ----------------------------------------------------------------------------------------
                return false
            end
            inst:DoTaskInTime(5,function() --- 穿越洞穴、重开存档的时候检查
                local last_flag_day = inst.components.sword_fairy_com_data:Get("need_2_stole_food_day_flag")
                if last_flag_day == TheWorld.state.cycles then -- 今天吃过了。
                    return                
                end
                if do_pilfer_food() then
                    inst.components.sword_fairy_com_data:Set("need_2_stole_food_day_flag",TheWorld.state.cycles)
                end
            end)

            inst:WatchWorldState("cycles",function() --- 新的一天到来的时候
                local last_flag_day = inst.components.sword_fairy_com_data:Get("need_2_stole_food_day_flag")
                if last_flag_day == TheWorld.state.cycles - 1 then -- 昨天吃过了
                    return
                else --- 昨天一整天都没吃东西
                    inst.components.sword_fairy_com_magic_point_sys:DoDelta(-7)
                end
                if do_pilfer_food() then
                    inst.components.sword_fairy_com_data:Set("need_2_stole_food_day_flag",TheWorld.state.cycles)                        
                end
            end)
        end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end