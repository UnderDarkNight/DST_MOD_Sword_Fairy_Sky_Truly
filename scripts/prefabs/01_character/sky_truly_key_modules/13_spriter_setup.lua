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
    local spriter_save_record_slots_index = "spriter_save_record_slots_index"
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 创建精灵并连接玩家
        local function CreateSpriter()
            ------------------------------------------------------------------------
            --- 前置检查
                if inst.___spriter ~= nil and inst.___spriter:IsValid() then
                    inst.___spriter:PushEvent("ClosePlayer")
                    return
                end
            ------------------------------------------------------------------------
            --- 创建并连接玩家
                local spriter_saved_record = inst.components.sword_fairy_com_data:Get(spriter_save_record_index)
                inst.components.sword_fairy_com_data:Set(spriter_save_record_index,nil)        
                if spriter_saved_record then
                    inst.___spriter = SpawnSaveRecord(spriter_saved_record)
                else
                    inst.___spriter = SpawnPrefab("sword_fairy_spriter")
                end
                local offset_pt = Vector3(math.random(10,25) * (math.random()<0.5 and 1 or -1) , 0 ,   math.random(10,25) * (math.random()<0.5 and 1 or -1)  )
                local player_pt = Vector3(inst.Transform:GetWorldPosition())
                inst.___spriter:PushEvent("Set",{
                    pt = Vector3(player_pt.x + offset_pt.x ,0, player_pt.z + offset_pt.z),
                    target = inst,
                })
                inst.___spriter:PushEvent("ClosePlayer")
            ------------------------------------------------------------------------
        end
        inst:ListenForEvent("create_spriter",CreateSpriter)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 储存 精灵数据
        local function SaveSpriterRecord()
            ------------------------------------------------------------------------
            -- 安全检查
                if inst.___spriter == nil then
                    return
                end
            ------------------------------------------------------------------------
            -- 玩家离开当前世界的时候
            ------------------------------------------------------------------------
            -- 丢掉物品
                inst.___spriter.components.container:DropEverythingWithTag("irreplaceable")
            ------------------------------------------------------------------------
            -- 获取储存代码
                inst.components.sword_fairy_com_data:Set(spriter_save_record_index , inst.___spriter:GetSaveRecord())
                inst.___spriter:Remove()
            ------------------------------------------------------------------------
            print("fake error : player_despawn and save spriter")
            ------------------------------------------------------------------------
        end
        inst:ListenForEvent("player_despawn",SaveSpriterRecord)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 初始化检查、定时检查
        inst:DoTaskInTime(0,function()
            if inst.components.playercontroller == nil then
                return
            end
            if inst.userid == nil then
                return
            end
            if inst.___spriter == nil then
                inst:PushEvent("create_spriter")
            else
                inst.___spriter:PushEvent("ClosePlayer")
            end
        end)
        inst:DoPeriodicTask(10,function()
            if inst.___spriter then                
                if inst.___spriter:IsAsleep() then
                    -- inst.___spriter.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    inst.___spriter:PushEvent("ClosePlayer")
                end
            else
                inst:PushEvent("create_spriter")       
            end
        end)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---
        function inst:GetSpriter()
            if inst.___spriter and inst.___spriter:IsValid() then
                return inst.___spriter
            end
            return nil
        end
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

end