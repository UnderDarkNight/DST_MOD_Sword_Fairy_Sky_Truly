-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    focalpoint     prefab

    TheFocalPoint   global inst client side

    hook 进去，进行声音等数据回传服务器

    battle sound 

    战斗音效回传

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- hook 进去的函数
        local function Hook_target_SoundEmitter(inst)

            if type(inst.SoundEmitter) == "userdata" then            ----- 只能转变一次，重复的操作 会导致  __index 函数错误
                --------------------------------------------------------------------------------------------------------------------------------
                    inst.__SoundEmitter_userdata_underworld_hana = inst.SoundEmitter      ----- 转移复制原有 userdata
                    inst.SoundEmitter = {inst = inst , name = "SoundEmitter"}   ----- name 是必须的，用于 从 _G  里 得到目标, 玩家 inst 也是从这里进入
                    ------ 逻辑上复现棱镜模组的代码：

                    setmetatable( inst.SoundEmitter , {
                        __index = function(_table,fn_name)
                                    if _table and _table.inst and _table.name then

                                            if _G[_table.name][fn_name] then    ---- 从_G全局里得到原函数？？这句并不好理解。   ---- lua 会往_G 里自动挂载所有要运行的 userdata ？？
                                                local _table_name = _table.name
                                                local fn = function(temp_table,...)
                                                    return _G[_table_name][fn_name](temp_table.inst.__SoundEmitter_userdata_underworld_hana,...)
                                                end
                                                rawset(_table,fn_name,fn)
                                                return fn
                                            end

                                    end
                        end,
                    })
                --------------------------------------------------------------------------------------------------------------------------------
            else
                print("warning : SoundEmitter is already a table ",inst)    
            end

            ------- 成功把  inst.SoundEmitter 从  userdata 变成 table
            --------------------- 挂载函数
            if inst.SoundEmitter.inst ~= inst then
                inst.SoundEmitter.inst = inst
            end
            ---------------------

        end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local tag_events = {
        ["danger"] = {
            ["start"] = function()
                print("fake error danger start")
                if ThePlayer then
                    ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("sword_fairy_event.danger_music_start")
                end
            end,
            ["stop"] = function()
                print("fake error danger stop")
                if ThePlayer then
                    ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("sword_fairy_event.danger_music_stop")
                end
            end
        },
    }
    local sound_event = {
        ["sound_name"] = function()
            
        end,
    }
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    AddPrefabPostInit(
        "focalpoint",
        function(inst)



                        
                    
                    Hook_target_SoundEmitter(inst)

                    if type(inst.SoundEmitter) ~= "table" then
                        print("error : hook focalpoint SoundEmitter fail")
                        return
                    else
                        print("info : hook focalpoint SoundEmitter succeed")
                    end

                    ------------------------------------------------------------------------------------
                    ----
                        local old_PlaySound = inst.SoundEmitter.PlaySound
                        inst.SoundEmitter.PlaySound = function(self,sound,tag,...)
                            -- print("TheFocalPoint",sound,tag)
                            old_PlaySound(self,sound,tag,...)
                            tag = tostring(tag)
                            if tag_events[tag] and tag_events[tag]["start"] then
                                tag_events[tag]["start"]()
                            end
                            if sound_event[sound] then
                                sound_event[sound]()
                            end
                        end
                    ------------------------------------------------------------------------------------
                    ---- 
                        local old_KillSound = inst.SoundEmitter.KillSound
                        inst.SoundEmitter.KillSound = function(self,tag,...)
                            -- print("TheFocalPoint kill ",tag)
                            old_KillSound(self,tag,...)
                            tag = tostring(tag)
                            if tag_events[tag] and tag_events[tag]["stop"] then
                                tag_events[tag]["stop"]()
                            end
                        end
                    ------------------------------------------------------------------------------------

                
            
        end
    )
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------