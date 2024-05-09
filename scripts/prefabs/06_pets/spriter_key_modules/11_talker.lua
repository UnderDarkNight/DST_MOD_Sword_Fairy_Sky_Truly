--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    say_block_for_player_per_day    -- 每天格挡的第一次
    say_refuse_food    -- 吃东西的时候

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function GetStringsTable(prefab_name)
        local temp_name = "sword_fairy_spriter"
        return TUNING["sword_fairy_sky_truly.fn"].GetStringsTable(temp_name or prefab_name)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 30
    inst.components.talker.font = TALKINGFONT
    inst.components.talker:SetOffsetFn(function()
        return Vector3(0,-350,0)
    end)

    if not TheWorld.ismastersim then
        return
    end
    ------------------------------------------------------------------------------
    --- 基础API
        local talk_cd_task = nil
        inst:ListenForEvent("Say",function(inst,cmd_table_or_str)
            if inst:HasTag("spriter_hat_active") then
                return
            end
            if talk_cd_task then
                inst:DoTaskInTime(2.5,function()
                   inst:PushEvent("Say",cmd_table_or_str)
                end)
                return
            end
            local _table = nil
            local str = nil
            local color = {255/255,150/255,255/255,1}
            if type(cmd_table_or_str) == "table" then
                _table = cmd_table_or_str
                str = tostring(_table.str)
                color = _table.color or color
            else
                str = tostring(cmd_table_or_str)
            end
            inst.components.talker:Say(str,nil,nil,nil,nil,color)
            ----------------------------------------------------------------------
            -- 播放声音
                local sound_addr = "dontstarve/characters/wendy/abigail/buff/attack"
                inst.SoundEmitter:PlaySound(sound_addr,"talk")
                inst:DoTaskInTime(1.5,function()
                    inst.SoundEmitter:KillSound("talk")                    
                end)
            ----------------------------------------------------------------------
            talk_cd_task = inst:DoTaskInTime(2,function()
                talk_cd_task = nil
            end)
        end)

        inst.Say_With_Index = function(inst,index)
            local str_or_table = GetStringsTable()[index] or ""
            local str = nil
            if type(str_or_table) == "table" then
                str = str_or_table[math.random(#str_or_table)]
            else
                str = str_or_table
            end
            print("info Say",str)
            inst:PushEvent("Say",str)
        end

    ------------------------------------------------------------------------------
    ----

        inst:ListenForEvent("say_block_for_player_per_day",function()
            inst:Say_With_Index("say.block_for_player")
        end)
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------
end