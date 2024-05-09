--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    拖尾特效处理

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    local fx = nil
    inst:ListenForEvent("start_fx",function()
        if inst:HasTag("spriter_hat_active") then
            return
        end
        if fx then
            return
        end
        fx = inst:SpawnChild("cane_candy_fx")
        fx.Transform:SetPosition(-0.5,1.5,0)
    end)
    inst:ListenForEvent("stop_fx",function()
        if fx then
            fx:Remove()
            fx = nil
        end
    end)

    inst:ListenForEvent("spriter_hat_active",function()
        inst:PushEvent("stop_fx")
    end)

end