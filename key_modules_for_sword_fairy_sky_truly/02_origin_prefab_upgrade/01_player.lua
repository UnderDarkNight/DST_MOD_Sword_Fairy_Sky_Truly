-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)
    
    if inst.components.sword_fairy_com_player_rotation == nil then
        inst:AddComponent("sword_fairy_com_player_rotation")
    end

    if not TheWorld.ismastersim then
        return
    end

    if inst.components.sword_fairy_com_data == nil then
        inst:AddComponent("sword_fairy_com_data")
    end
    if inst.components.sword_fairy_com_rpc_event == nil then
        inst:AddComponent("sword_fairy_com_rpc_event")
    end
    if inst.components.sword_fairy_com_fast_cooker == nil then
        inst:AddComponent("sword_fairy_com_fast_cooker")
    end


end)





