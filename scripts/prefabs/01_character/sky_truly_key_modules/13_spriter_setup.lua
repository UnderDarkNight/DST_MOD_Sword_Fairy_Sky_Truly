--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    inst:GetSaveRecord()

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local spriter_save_record_index = "spriter_save_record_index"
    local spriter_inst = nil

    inst:DoTaskInTime(0,function()
        
        local spriter_saved_record = inst.components.sword_fairy_com_data:Get(spriter_save_record_index)
        inst.components.sword_fairy_com_data:Set(spriter_save_record_index,nil)

        
        if spriter_saved_record then
            spriter_inst = SpawnSaveRecord(inst,spriter_saved_record)
        else
            spriter_inst = SpawnPrefab("sword_fairy_spriter")
        end

        local offset_pt = Vector3(math.random(10,25) * (math.random()<0.5 and 1 or -1) , 0 ,   math.random(10,25) * (math.random()<0.5 and 1 or -1)  )
        local player_pt = Vector3(inst.Transform:GetWorldPosition())
        spriter_inst:PushEvent("Set",{
            pt = Vector3(player_pt.x + offset_pt.x ,0, player_pt.z + offset_pt.z),
            target = inst,
        })



        inst.components.sword_fairy_com_data:AddOnSaveFn(function()
            ------------------------------------------------------------------------
            -- 玩家离开当前世界的时候
            ------------------------------------------------------------------------
            -- 先丢弃任何不能带离存档的东西
            ------------------------------------------------------------------------
            -- 获取储存代码
                inst.components.sword_fairy_com_data:Set(spriter_save_record_index , spriter_inst:GetSaveRecord())
                spriter_inst:Remove()
            ------------------------------------------------------------------------
        end)

    end)

end