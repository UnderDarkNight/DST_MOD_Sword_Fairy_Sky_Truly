--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    地图传送

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    ----------------------------------------------------------------------------------------------
    --- 关闭地图event
        inst:DoTaskInTime(1,function()  
            if inst.HUD then
                inst:ListenForEvent("sword_fairy_event.ToggleMap",function()
                    inst.HUD.controls:ToggleMap()
                end)
            end

        end)
    ----------------------------------------------------------------------------------------------
    ---- 消耗
        local MP_COST = 0
    ----------------------------------------------------------------------------------------------
    ---- jumper 组件
        inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_map_jumper",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,pt)
                if not TheWorld.Map:IsAboveGroundAtPoint(pt.x,pt.y,pt.z) then
                    return false
                end
                if inst.replica.sword_fairy_com_magic_point_sys:GetCurrent() < MP_COST then
                    return false
                end
                return true
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("sword_fairy_com_map_jumper")

            inst.components.sword_fairy_com_map_jumper:SetPreSpellFn(function(inst,pt)
                inst.components.sword_fairy_com_rpc_event:PushEvent("sword_fairy_event.ToggleMap") ---- 下发关闭地图的命令                
            end)

            inst.components.sword_fairy_com_map_jumper:SetSpellFn(function(inst,pt)
                ----------------------------------------------------------------------------------------------
                -- 资源消耗
                    inst.components.sword_fairy_com_map_jumper:DoDelta(-1)
                    inst.components.sword_fairy_com_magic_point_sys:DoDelta(-MP_COST)
                ----------------------------------------------------------------------------------------------
                -- 这里可以添加一些传送后需要执行的代码
                    local x,y,z = pt.x,pt.y,pt.z
                    if inst.components.playercontroller ~= nil then
                        inst.components.playercontroller:RemotePausePrediction(10)   --- 暂停远程预测。  --- 暂停10帧预测
                        inst.components.playercontroller:Enable(false)
                    end
                    inst.Transform:SetPosition(x,y,z)
                    if inst.Physics then
                        inst.Physics:Teleport(x,y,z)
                    end
                    inst:DoTaskInTime(0.1,function()
                        if inst.components.playercontroller ~= nil then
                            inst.components.playercontroller:Enable(true)
                        end
                    end)
                ----------------------------------------------------------------------------------------------

            end)

        end
    ----------------------------------------------------------------------------------------------


end