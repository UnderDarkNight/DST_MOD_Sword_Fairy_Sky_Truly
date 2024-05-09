--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    inst:ListenForEvent("spriter_hat_active",function()
        inst.components.container:Close()
        inst.components.container.canbeopened = false
    end)
    inst:ListenForEvent("spriter_hat_inactive",function()
        inst.components.container.canbeopened = true        
    end)


end