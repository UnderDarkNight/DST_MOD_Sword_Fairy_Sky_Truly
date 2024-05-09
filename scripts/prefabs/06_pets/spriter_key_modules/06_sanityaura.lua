--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    sanityaura 光环组件。  1/min 的参数为 TUNING.SANITYAURA_MED/40

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local param_sanity_delta_1_by_1_min = TUNING.SANITYAURA_MED/40   --- 

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = function(inst, observer)
        if inst:HasTag("spriter_hat_active") then
            return 0
        end
        if observer and inst:GetLinkedPlayer() == observer then
            local current_mp = inst.components.sword_fairy_com_magic_point_sys:GetCurrent()        
            return param_sanity_delta_1_by_1_min*current_mp*0.1
        end
        return 0
    end
    inst.components.sanityaura.fallofffn = function() --- 下降梯度
        return 1
    end




end