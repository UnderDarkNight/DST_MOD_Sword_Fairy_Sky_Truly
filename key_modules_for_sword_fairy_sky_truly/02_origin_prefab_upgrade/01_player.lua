-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.sword_fairy_com_data == nil then
        inst:AddComponent("sword_fairy_com_data")
    end
    if inst.components.sword_fairy_com_rpc_event == nil then
        inst:AddComponent("sword_fairy_com_rpc_event")
    end

end)





