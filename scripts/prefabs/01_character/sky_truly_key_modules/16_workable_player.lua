--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_workable",function(inst,replica_com)
        inst:DoTaskInTime(1,function()
            
            replica_com:SetSGAction("give")
            replica_com:SetText("sword_fairy_spriter_in_plaer",STRINGS.ACTIONS.ACTIVATE.PICK_FLOWER)
            replica_com:SetTestFn(function(inst,doer,right_click)
                -- print(" ++ sword_fairy_com_workable in player  test fn")
                if not right_click then
                    return false
                end
                if inst ~= doer then
                    return false
                end
                if not inst:HasTag("spriter_hat_active") then
                    return false
                end
                return true
            end)

        end)
    end)
    if TheWorld.ismastersim then
        inst:AddComponent("sword_fairy_com_workable")
        inst.components.sword_fairy_com_workable:SetActiveFn(function(inst,doer)
            doer:PushEvent("hide_spriter_hat")
            local spriter = inst:GetSpriter()
            if spriter then
                spriter:PushEvent("spriter_hat_inactive")
            end
            return true
        end)

    end

end