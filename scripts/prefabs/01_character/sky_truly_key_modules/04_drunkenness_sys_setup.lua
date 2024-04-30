--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("sword_fairy_com_drunkenness")
    inst.components.sword_fairy_com_drunkenness.current = 0
    inst.components.sword_fairy_com_drunkenness.max = 70

    local drunkenness_dodelta_value = inst.components.sword_fairy_com_drunkenness:GetIntoxicatedValue()/480 -- 一天480秒

    inst:DoPeriodicTask(1,function()
        if inst:HasTag("playerghost") then
            return
        end
        ------ 醉意值 太小，造成每秒伤害
            if inst.components.sword_fairy_com_drunkenness.current <= 1 then
                local damage = 1
                if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                    damage = 0
                end
                inst.components.health:DoDelta(-damage,nil,"sword_fairy_other_drunkenness_damage")
            end
        ------ 定时减少数值
            inst.components.sword_fairy_com_drunkenness:DoDelta(-drunkenness_dodelta_value)

    end)



end