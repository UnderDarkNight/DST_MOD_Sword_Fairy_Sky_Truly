------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    -- local player = inst.entity:GetParent()
    inst.target = target
    local player = inst.target
    -----------------------------------------------------
    ---
        if not player.components.sword_fairy_com_data then
            inst:Remove()
            return
        end
    -----------------------------------------------------
    ---
        local index = "sword_fairy_food_sacred_wine_hunger"
        local index_max = "sword_fairy_food_sacred_wine_hunger_max_per_day"
        local current_value = player.components.sword_fairy_com_data:Add(index,0)
        if current_value <= 0 then
            inst:Remove()
            return
        end
    -----------------------------------------------------
    --- 每秒执行一次。
        local max = player.components.sword_fairy_com_data:Get(index_max)
        local delta = max/480
        inst:DoPeriodicTask(1,function()
            local current_value = player.components.sword_fairy_com_data:Add(index,-delta)            
            if current_value <= 0 then
                inst:Remove()
                return
            end
            player.components.hunger:DoDelta(delta,true)
        end)
    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
    -- local player = inst.entity:GetParent()
    local player = inst.target

end

local function OnUpdate(inst)
    -- local player = inst.entity:GetParent()
    local player = inst.target

end

local function ExtendDebuff(inst)
    -- inst.countdown = 3 + (inst._level:value() < CONTROL_LEVEL and EXTEND_TICKS or math.floor(TUNING.STALKER_MINDCONTROL_DURATION / FRAMES + .5))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("sword_fairy_debuff_sacred_wine", fn)
