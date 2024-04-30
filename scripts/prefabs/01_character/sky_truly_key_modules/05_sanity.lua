--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    理智值相关的

    黄昏不降低理智值。
    理智值受到光环影响都是1/7倍率。
    进入战斗后，每7秒增加1点理智值。
    穿戴护甲后移动速度降低70%，且精神值每7秒减少1点。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function sanity_up_by_battle_stask_start()
        
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("master_postinit_sword_fairy_sky_truly",function()

        ------------------------------------------------------------------------------------------------------------
        --- 倍增器inst
            local temp_inst = CreateEntity()
            temp_inst:ListenForEvent("onremove",function()
                temp_inst:Remove()
            end,inst)

        ------------------------------------------------------------------------------------------------------------
        ---- 黄昏不掉理智
            -- ThePlayer.components.sanity.externalmodifiers:SetModifier(ThePlayer,-TUNING.SANITY_NIGHT_MID)
            local function modifier_setup_by_dusk()
                inst:DoTaskInTime(1,function()
                    if TheWorld.state.isdusk then
                        inst.components.sanity.externalmodifiers:SetModifier(temp_inst,-TUNING.SANITY_NIGHT_MID)
                    else
                        inst.components.sanity.externalmodifiers:SetModifier(temp_inst,0)
                    end
                end)
            end
            inst:DoTaskInTime(1,modifier_setup_by_dusk)
            inst:WatchWorldState("phase", modifier_setup_by_dusk)
        ------------------------------------------------------------------------------------------------------------
        ---- 战斗,每7秒回复1点
            local battle_sanity_up_task = nil
            inst:ListenForEvent("sword_fairy_event.danger_music_start",function()
                if battle_sanity_up_task == nil then
                    battle_sanity_up_task = inst:DoPeriodicTask(1,function()
                        inst.components.sanity:DoDelta(1/7,true)
                    end)
                end
            end)
            inst:ListenForEvent("sword_fairy_event.danger_music_stop",function()
                if battle_sanity_up_task ~= nil then
                    battle_sanity_up_task:Cancel()
                    battle_sanity_up_task = nil
                end
            end)
        ------------------------------------------------------------------------------------------------------------
        --- 光环造成的任何影响都是1/7
            inst.components.sanity.neg_aura_modifiers:SetModifier(temp_inst,1/7)
        ------------------------------------------------------------------------------------------------------------
        --- 穿戴护甲后移动速度降低70%，且精神值每7秒减少1点。
            local sanity_down_task_by_armor = nil

            local function mult_by_armor()
                local has_armor = false
                inst.components.inventory:ForEachEquipment(function(item)   --- 用官方的API遍历装备栏
                    if has_armor then
                        return
                    end
                    if item and item.components.armor then
                        has_armor = true
                    end
                end)

                if has_armor then
                    ---- 有护甲，降速、降San任务
                    if sanity_down_task_by_armor == nil then
                        sanity_down_task_by_armor = inst:DoPeriodicTask(1,function()
                            inst.components.sanity:DoDelta(-1/7,true)
                        end)
                    end
                    inst.components.locomotor:SetExternalSpeedMultiplier(temp_inst, "sword_fairy_sky_truly_speed_by_sanity_and_armor",0.3)
                else
                    ---- 移除倍增器 和 降San任务
                    inst.components.locomotor:SetExternalSpeedMultiplier(temp_inst, "sword_fairy_sky_truly_speed_by_sanity_and_armor",1)
                    if sanity_down_task_by_armor ~= nil then
                        sanity_down_task_by_armor:Cancel()
                        sanity_down_task_by_armor = nil
                    end
                end
            end
            inst:ListenForEvent("unequip",mult_by_armor)
            inst:ListenForEvent("equip",mult_by_armor)
            inst:DoTaskInTime(1,mult_by_armor)
        ------------------------------------------------------------------------------------------------------------




    end)
end