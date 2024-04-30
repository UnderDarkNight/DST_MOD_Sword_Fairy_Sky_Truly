--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

     所有物品挂上 交互组件，触发交互 函数。
     玩家身上挂上 检查组件和函数。
     
     
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




local SWORD_FAIRY_COM_FOOD_REFUSER = Action({priority = 999})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
SWORD_FAIRY_COM_FOOD_REFUSER.id = "SWORD_FAIRY_COM_FOOD_REFUSER"
SWORD_FAIRY_COM_FOOD_REFUSER.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    local item = act.invobject
    local target = act.target
    local doer = act.doer
    if target == nil then --- 自己吃的时候
        return "DEFAULT"
    else
        return "FEED"    
    end
end

SWORD_FAIRY_COM_FOOD_REFUSER.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    local target = act.target
    local doer = act.doer

    if target == nil then --- 自己吃的时候        
    
            local replica_com = doer.replica.sword_fairy_com_food_refuser or doer.replica._.sword_fairy_com_food_refuser
            if replica_com and replica_com:IsRefuse(item)   then
                local str = doer.components.sword_fairy_com_food_refuser:GetRefuseReason(item)
                doer.components.talker:Say(str)
            end
            return true

    else    --- 别人喂的时候
            local replica_com = target.replica.sword_fairy_com_food_refuser or target.replica._.sword_fairy_com_food_refuser
            if replica_com and replica_com:IsRefuse(item) then
                local str = target.components.sword_fairy_com_food_refuser:GetRefuseReason(item)
                target.components.talker:Say(str)                
            end
            return false
    end
end
AddAction(SWORD_FAIRY_COM_FOOD_REFUSER)

--- 【重要笔记】AddComponentAction 函数有陷阱，一个MOD只能对一个组件添加一个动作。
--- 【重要笔记】例如AddComponentAction("USEITEM", "inventoryitem", ...) 在整个MOD只能使用一次。
--- 【重要笔记】modname 参数伪装也不能绕开。


-- AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
-- AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
-- AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
-- AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。

-- 在后续注册了，这里暂时注释掉。


AddComponentAction("INVENTORY", "edible" , function(item, doer, actions, right) 
    if item and doer then
        local replica_com = doer.replica.sword_fairy_com_food_refuser or doer.replica._.sword_fairy_com_food_refuser
        if replica_com and replica_com:IsRefuse(item) then
            table.insert(actions, ACTIONS.SWORD_FAIRY_COM_FOOD_REFUSER)
        end
    end
end)
AddComponentAction("USEITEM","edible",function(item,doer,target,actions,right)
    if item and target and right then
        -- print("info USEITEM edible",doer,target)
        local replica_com = target.replica.sword_fairy_com_food_refuser or target.replica._.sword_fairy_com_food_refuser
        if replica_com and replica_com:IsRefuse(item) then
            table.insert(actions,ACTIONS.SWORD_FAIRY_COM_FOOD_REFUSER)
        end
    end
end)


local handler_fn = function(player)

    -- return "give"
    return "sword_fairy_sg_action_refuse"
end

AddStategraphActionHandler("wilson",ActionHandler(SWORD_FAIRY_COM_FOOD_REFUSER,function(player)
    return handler_fn(player)
end))
AddStategraphActionHandler("wilson_client",ActionHandler(SWORD_FAIRY_COM_FOOD_REFUSER, function(player)
    return handler_fn(player)
end))


STRINGS.ACTIONS.SWORD_FAIRY_COM_FOOD_REFUSER = STRINGS.ACTIONS.SWORD_FAIRY_COM_FOOD_REFUSER or {
    DEFAULT = STRINGS.ACTIONS.EAT,
    FEED = STRINGS.ACTIONS.FEEDPLAYER,
}



