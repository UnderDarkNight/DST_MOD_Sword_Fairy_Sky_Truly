--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

STRINGS.ACTIONS.ATTUNE

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)


    inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_workable",function(inst,replica_com)
        replica_com:SetSGAction("give")
        replica_com:SetText("sword_fairy_spriter",STRINGS.ACTIONS.ATTUNE)
        replica_com:SetTestFn(function(inst,doer,right_click)
            if not right_click then
                return false
            end
            if inst:GetLinkedPlayer() ~= doer then
                return false
            end
            if doer.replica.inventory:GetActiveItem() then
                return false
            end
            return true
        end)
    end)
    if TheWorld.ismastersim then
        inst:AddComponent("sword_fairy_com_workable")
        inst.components.sword_fairy_com_workable:SetActiveFn(function(inst,doer)
            inst:PushEvent("spriter_hat_active")            
            doer:PushEvent("show_spriter_hat")
            return true
        end)

        inst:ListenForEvent("spriter_hat_active",function(inst) --- 上tag
            inst:AddTag("spriter_hat_active")
            inst:Hide()
        end)        
        inst:ListenForEvent("spriter_hat_inactive",function(inst)  --- 下tag
            inst:RemoveTag("spriter_hat_active")
            inst:Show()
            local player = inst:GetLinkedPlayer()
            if player then
                inst.Transform:SetPosition(player.Transform:GetWorldPosition())
            end
        end)

    end



end