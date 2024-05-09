--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end



    local hat_inst = SpawnPrefab("sword_fairy_spriter_hat")
    hat_inst.entity:SetParent(inst.entity)
    hat_inst.entity:AddFollower()
    hat_inst.Follower:FollowSymbol(inst.GUID, "headbase",0,-150, 0)
    hat_inst:Hide()

    inst:ListenForEvent("show_spriter_hat", function()
       hat_inst:Show()
       inst:AddTag("spriter_hat_active")
    end)
    inst:ListenForEvent("hide_spriter_hat", function()
       hat_inst:Hide()
       inst:RemoveTag("spriter_hat_active")
    end)

end