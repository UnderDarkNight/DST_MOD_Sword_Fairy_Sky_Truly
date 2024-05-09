--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    伤害倍增器。打BOSS解锁

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local index = "damage_mult_unlock_flag_by_boss"

    inst:ListenForEvent("sowrd_fairy_event.unlock_mult", function(inst)
        -------------------------------------------------------------------------------------------------------
        --- 对目标阵营伤害倍增器
            if inst.components.damagetypebonus == nil then
                inst:AddComponent("damagetypebonus")
            end
            inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, 1 + 0.07)  --- 对暗影阵营伤害 倍增
            inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, 1 + 0.07)   --- 对月亮阵营伤害 倍增
        -------------------------------------------------------------------------------------------------------
        --- 受到阵营伤害倍增器
            if inst.components.damagetyperesist == nil then
                inst:AddComponent("damagetyperesist")
            end
            inst.components.damagetyperesist:AddResist("shadow_aligned", inst, 1 - 0.07)    --- 来自暗影阵营伤害 倍减
            inst.components.damagetyperesist:AddResist("lunar_aligned", inst, 1 - 0.07)    --- 来自暗影阵营伤害 倍减
        -------------------------------------------------------------------------------------------------------
        -- debug 提示
            if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                TheNet:Announce("阵营伤害倍增器解锁")
            end
        -------------------------------------------------------------------------------------------------------

    end)

    -------------------------------------------------------------------------------------------------------
    ---- 每次攻击有7%的几率额外召唤一把飞剑
        inst:ListenForEvent("onhitother", function(inst,_table)
            local target = _table and _table.target
            if not ( target and target:IsValid() and target.components.combat ) then
                return
            end
            if not inst.components.sword_fairy_com_data:Get(index) then
                return
            end
            if target.__temp_flag_by_auto_flying_sword then
                return
            end
            if math.random(1000) <= 70 or TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                target.__temp_flag_by_auto_flying_sword = true
                inst:PushEvent("extra_sword_fx_for_target",{
                    target = target,
                    animover_fn = function()
                        target.__temp_flag_by_auto_flying_sword = nil
                    end,
                })
            end
        end)
    -------------------------------------------------------------------------------------------------------
    ---- 解锁事件 和初始化
        inst:ListenForEvent("killed", function(inst,_table)
            local target = _table and _table.victim
            if not (target and target:HasTag("epic")) then
                return
            end

            if inst.components.sword_fairy_com_data:Get(index) then
                return
            end        
            inst.components.sword_fairy_com_data:Set(index,true)
            inst:PushEvent("sowrd_fairy_event.unlock_mult")
        end)
        inst.components.sword_fairy_com_data:AddOnLoadFn(function()
            if inst.components.sword_fairy_com_data:Get(index) then
                inst:PushEvent("sowrd_fairy_event.unlock_mult")
            end
        end)
    -------------------------------------------------------------------------------------------------------



end