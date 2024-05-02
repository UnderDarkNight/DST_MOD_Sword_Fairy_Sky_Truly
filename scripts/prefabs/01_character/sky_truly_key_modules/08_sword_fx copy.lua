--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【剑来】    
    【r键按一次激活，再按一次取消该状态，召唤3把【本命飞剑】到手中（环绕身边就行），激活状态下每秒消耗1点法力值】
    
    本命飞剑伤害=【10+法力值上限/7的真实伤害】+【法力值上限/7位面伤害】，
    
    3把飞剑可以进行攻击，每2s攻击一次，范围5*5单体，跟随玩家打，玩家没打，
    
    就去打有敌意的，自己也可以攻击，
    
    每七次攻击造成1次大范围剑舞伤害=【10+法力值上限/7的真实伤害】+【法力值上限/7位面伤害】（5*5全体）（三把剑都飞出去那种），
    且该伤害会额外造成生物生命上限1%的伤害】

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(1,function()

        ----------------------------------------------------------------------------------------------------------------------------
        --- 
            local max_sword_num = 3
            local sword_inst_for_dmg = inst:SpawnChild("sword_fairy_flying_sword_for_fx_damage")
            local sword_inst_for_dmg_attack_num = 0
            local sword_surround_active_flag = false
            
        ----------------------------------------------------------------------------------------------------------------------------
        --- 特效伤害更新
            local sword_inst_for_dmg_update = function()
                local player_mp_max = inst.components.sword_fairy_com_magic_point_sys:GetMax()
                sword_inst_for_dmg.components.weapon:SetDamage(10 + player_mp_max/7 )
                sword_inst_for_dmg.components.planardamage:SetBaseDamage(player_mp_max/7)
            end
        ----------------------------------------------------------------------------------------------------------------------------
        --- 
            local data = inst.components.sword_fairy_com_data
            data:Add("flying_sword",0)
        ----------------------------------------------------------------------------------------------------------------------------
        --- 创建环绕特效常驻玩家。
            local cycle_fx = inst:SpawnChild("sword_fairy_sfx_sword_cycle")
            cycle_fx:PushEvent("Set")
            cycle_fx:ListenForEvent("sword_fairy_com_player_rotation",function(player)
                local ret_angle = 0 - player.Transform:GetRotation()
                ------- 把角度限制在 -180 到 180度内
                    if ret_angle > 180 then
                        ret_angle = ret_angle - 360                
                    elseif ret_angle < -180 then
                        ret_angle = ret_angle + 360                
                    end
                    
                    cycle_fx.Transform:SetRotation(ret_angle)
            end,inst)

            ------ 隐藏所有剑
                inst:ListenForEvent("hide_all_sword_fx",function()
                    for i = 1, max_sword_num, 1 do
                        cycle_fx:PushEvent("sword",{
                            num = i,
                            fn = function(sword_fx)
                                sword_fx:PushEvent("hide")
                            end,
                        })
                    end
                end)
                inst:ListenForEvent("leave_all_sword_fx",function()
                    local current = data:Add("flying_sword",0)
                    for i = 1, current, 1 do
                        cycle_fx:DoTaskInTime((i-1)*0.2,function()
                            cycle_fx:PushEvent("sword",{
                                num = i,
                                fn = function(sword_fx)
                                    sword_fx:PushEvent("leave")
                                end,
                            })
                        end)
                    end
                end)
            ------ 显示当前拥有的剑
                inst:ListenForEvent("show_current_sword_fx",function()
                    local current = data:Add("flying_sword",0)
                    for i = 1, current, 1 do
                        cycle_fx:DoTaskInTime((i-1)*0.2,function()
                            cycle_fx:PushEvent("sword",{
                                num = i,
                                fn = function(sword_fx)
                                    sword_fx:PushEvent("join")
                                end,
                            })
                        end)
                    end
                end)
        ----------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------
        ---- 初始化隐藏全部
            inst:PushEvent("hide_all_sword_fx")
            -- inst:PushEvent("show_current_sword_fx")
        ----------------------------------------------------------------------------------------------------------------------------
        ---- 添加/移除特效
            inst:ListenForEvent("add_sword_fx",function()
                local current = data:Add("flying_sword",0)
                if current >= max_sword_num then
                    data:Set("flying_sword",max_sword_num)
                    return
                end
                local ret = data:Add("flying_sword",1)
                cycle_fx:PushEvent("sword",{
                    num = ret,
                    fn = function(sword_fx)
                        sword_fx:PushEvent("down",function(sword_fx)
                            sword_fx:AddTag("Ready")
                        end)
                    end
                })
            end)
            
            inst:ListenForEvent("remove_sword_fx",function()
                local current = data:Add("flying_sword",0)
                if current <= 0 then
                    data:Set("flying_sword",0)
                    return
                end
                cycle_fx:PushEvent("sword",{
                    num = current,
                    fn = function(sword_fx)
                        if sword_fx:HasTag("Ready") then
                            sword_fx:PushEvent("leave")
                            sword_fx:RemoveTag("Ready")
                            data:Add("flying_sword",-1)
                        end
                    end,
                })
            end)
            ----------------------------------------------------------------------------------------------------------------------
            ---- 移除剑并攻击目标
                inst:ListenForEvent("remove_sword_fx_for_target",function(inst,target)
                    local current = data:Add("flying_sword",0)
                    if current <= 0 then
                        data:Set("flying_sword",0)
                        return
                    end
                    cycle_fx:PushEvent("sword",{
                        num = current,
                        fn = function(sword_fx)
                                if sword_fx:HasTag("Ready") then
                                    data:Add("flying_sword",-1)
                                    sword_fx:RemoveTag("Ready")
                                    sword_fx:PushEvent("up",function(sword_fx)
                                        sword_fx:Hide()
                                        ---------------------------------------------------
                                        ---------------------------------------------------
                                        --- 开始往目标身上戳
                                            SpawnPrefab("sword_fairy_sfx_flying_sword_hit"):PushEvent("Set",{
                                                target = target,
                                                speed = 1.5,
                                                onhit_fn = function(sword_hit_fx)
                                                    if target.components.combat then
                                                        sword_inst_for_dmg_update()
                                                        -- 【笔记】为了实现玩家自身的伤害加成，得走玩家攻击API
                                                        inst.components.combat:DoAttack(target,sword_inst_for_dmg) --- 玩家使用特定武器inst攻击目标
                                                    end
                                                    ----------------------------------------------------------------
                                                    ----- 7次攻击进行一次AOE
                                                        if sword_inst_for_dmg_attack_num >= (TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 3 or 7)  then
                                                            
                                                            sword_inst_for_dmg_attack_num = 0
                                                            sword_hit_fx:Remove()
                                                            local x,y,z = target.Transform:GetWorldPosition()
                                                            SpawnPrefab("sword_fairy_sfx_flying_sword_aoe"):PushEvent("Set",{
                                                                pt = Vector3(x,0.5,z),
                                                                fn = function()
                                                                    sword_inst_for_dmg:AddTag("AOE")
                                                                    sword_inst_for_dmg_update()
                                                                    local musthavetags = { "_combat" }
                                                                    local canthavetags = {"INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "player", "companion"}
                                                                    local musthaveoneoftags = nil
                                                                    local ents = TheSim:FindEntities(x, y, z, 10, musthavetags, canthavetags, musthaveoneoftags)
                                                                    for _,v in pairs(ents) do
                                                                        if v.components.combat and inst.components.combat:CanAttack(v) then
                                                                            inst.components.combat:DoAttack(target,sword_inst_for_dmg) --- 玩家使用特定武器inst攻击目标
                                                                        end
                                                                    end
                                                                    sword_inst_for_dmg:RemoveTag("AOE")

                                                                    inst:PushEvent("add_sword_fx")

                                                                end,
                                                            })                                                    
                                                        end
                                                    ----------------------------------------------------------------
                                                end,
                                                on_leave_fn = function(sword_hit_fx) --- 重新回到玩家身边
                                                    if sword_surround_active_flag then
                                                        inst:PushEvent("add_sword_fx")
                                                    end
                                                end,
                                            })
                                        ---------------------------------------------------
                                    end)
                                    
                                end
                        end,
                    })
                end)
            ----------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------
        --- 按键激活
            local mp_down_task = nil
            local function stop_mp_down_task()
                if mp_down_task then
                    mp_down_task:Cancel()
                    mp_down_task = nil
                end
            end
            local function start_mp_down_task()
                if mp_down_task then
                    return
                end
                mp_down_task = inst:DoPeriodicTask(1,function()
                    inst.components.sword_fairy_com_magic_point_sys:DoDelta(-1)
                    if inst.components.sword_fairy_com_magic_point_sys:GetCurrent() <= 0 then
                        stop_mp_down_task()
                        sword_surround_active_flag = false
                        inst:PushEvent("leave_all_sword_fx")
                    end
                end)
            end
            
            local key_press_cd_task = nil
            inst:ListenForEvent("sword_fairy_spell_key_press.CALL_SWORD",function(inst)
                if key_press_cd_task then
                    return
                end
                key_press_cd_task = inst:DoTaskInTime(1,function()
                    key_press_cd_task = nil
                end)

                if not sword_surround_active_flag then
                    if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                        inst.components.sword_fairy_com_magic_point_sys:DoDelta(100)
                    end
                    local MP = inst.components.sword_fairy_com_magic_point_sys:GetCurrent()
                    if MP <= 3 then
                        inst.components.sword_fairy_com_rpc_event:PushEvent("sword_fairy_spell.fail") -- 法力不足
                        return
                    end
                    start_mp_down_task()
                    sword_surround_active_flag = true
                   
                    data:Set("flying_sword",max_sword_num)
                    inst:PushEvent("show_current_sword_fx")

                    print("激活本命飞剑")
                    TheNet:Announce("激活本命飞剑")

                else
                    sword_surround_active_flag = false
                    stop_mp_down_task()
                    inst:PushEvent("leave_all_sword_fx")

                    TheNet:Announce("取消飞剑")
                end
            end)
        ----------------------------------------------------------------------------------------------------------------------------
        --- on hit other 
            local sword_hit_cd_task = nil
            inst:ListenForEvent("onattackother",function(inst,_table)
                if not sword_surround_active_flag then
                    return
                end
                if sword_hit_cd_task then
                    return
                end

                _table = _table or {}
                local target = _table.target
                local weapon = _table.weapon
                if weapon == sword_inst_for_dmg then
                    if not sword_inst_for_dmg:HasTag("AOE") then
                        sword_inst_for_dmg_attack_num = sword_inst_for_dmg_attack_num + 1                        
                    end
                    return
                end

                inst:PushEvent("remove_sword_fx_for_target",target)

                sword_hit_cd_task = inst:DoTaskInTime(1,function()
                    sword_hit_cd_task = nil
                end)
            end)
        ----------------------------------------------------------------------------------------------------------------------------

        









    end)
end