--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【安康之力】当你的血量低于上限的7%，7秒内获得霸体（不僵直也不受到伤害），防御力变为100%，状态结束后后血量变化为满血量，冷却时间7天

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local temp_inst = CreateEntity()
    temp_inst:ListenForEvent("onremove",function()
        temp_inst:Remove()
    end,inst)

    local REMAIN_TIME = 7   --- 持续时间

    local function can_start_spell()
        local last_spell_casted_day = inst.components.sword_fairy_com_data:Get("power_of_peace_day")
        if last_spell_casted_day == nil then
            return true
        end
        if TheWorld.state.cycles - last_spell_casted_day >= 7 then
            return true
        end
        return false
    end

    local time_task = nil
    local fx_display_fn = function()
        local fx = inst:SpawnChild("sword_fairy_sfx_shadow_shell")
        fx:PushEvent("Set",{
            color = Vector3(0,100,255),
            a = 0.5,
            speed = 2,
            MultColour_Flag = true,
            -- type = 1,
        })
    end

    inst:ListenForEvent("healthdelta", function(inst, _table)

        if inst.components.health:GetPercent() <= 0.07 and time_task == nil and can_start_spell() then
            time_task = inst:DoTaskInTime(REMAIN_TIME, function()
                time_task = nil
                inst.components.combat.externaldamagetakenmultipliers:SetModifier(temp_inst,1)
                inst.components.health.penalty = 0
                inst.components.health:SetPercent(1)
            end)
            inst.components.combat.externaldamagetakenmultipliers:SetModifier(temp_inst,0)
            inst.components.sword_fairy_com_data:Set("power_of_peace_day",TheWorld.state.cycles)
            for i = 0, REMAIN_TIME*2 , 1 do                
                inst:DoTaskInTime(i/2, fx_display_fn)
            end
        end
    end)


end