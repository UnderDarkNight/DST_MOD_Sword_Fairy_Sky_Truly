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
            -- local current_free_num = 3
            local sword_inst_for_dmg = inst:SpawnChild("sword_fairy_flying_sword_for_fx_damage")
            local sword_inst_for_dmg_attack_num = 0
            local sword_surround_active_flag = false
            
        ----------------------------------------------------------------------------------------------------------------------------
        --- 特效伤害更新
            local sword_inst_for_dmg_update = function(is_aoe_attack)
                if is_aoe_attack then
                    local player_mp_max = inst.components.sword_fairy_com_magic_point_sys:GetMax()
                    sword_inst_for_dmg.components.weapon:SetDamage(10 + player_mp_max/7 )
                    sword_inst_for_dmg.components.planardamage:SetBaseDamage(player_mp_max/7)
                else
                    local player_mp_max = inst.components.sword_fairy_com_magic_point_sys:GetMax()
                    sword_inst_for_dmg.components.weapon:SetDamage(10 + player_mp_max/7 )
                    sword_inst_for_dmg.components.planardamage:SetBaseDamage(player_mp_max/7)
                end
            end
        ----------------------------------------------------------------------------------------------------------------------------
        --- 计数器
            -- local data = inst.components.sword_fairy_com_data
            -- data:Set("sword_num",0)
            -- local function Sword_Num_Add(num)
            --     return data:Add("sword_num",num)
            -- end
            -- local function Sword_Num_Get()
            --     return data:Get("sword_num")
            -- end
        ----------------------------------------------------------------------------------------------------------------------------
        --- 创建环绕特效常驻玩家。
            local cycle_fx = inst:SpawnChild("sword_fairy_sfx_sword_cycle")
            if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                inst.cycle_fx = cycle_fx
            end
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
        ----------------------------------------------------------------------------------------------------------------------------
        --- 环绕的剑inst ， 初始化隐藏所有
            local cycle_swords_fx = cycle_fx.sword
            for i = 1, max_sword_num, 1 do
                cycle_swords_fx[i]:PushEvent("hide")
                cycle_swords_fx[i].BUSY = false
                cycle_swords_fx[i].num = i
                cycle_swords_fx[i].UP_FLAG = true   --- 在顶部

            end
            local function GetFreeSword()
                for i = 1, max_sword_num, 1 do
                    if cycle_swords_fx[i].BUSY == false then
                        return cycle_swords_fx[i]
                    end
                end
                return nil
            end
            local function GetFreeSword_UP()
                for i = 1, max_sword_num, 1 do
                    if cycle_swords_fx[i].BUSY == false and cycle_swords_fx[i].UP_FLAG then
                        return cycle_swords_fx[i]
                    end
                end
                return nil
            end
            local function GetFreeSword_DOWN()
                for i = 1, max_sword_num, 1 do
                    if cycle_swords_fx[i].BUSY == false and not cycle_swords_fx[i].UP_FLAG then
                        return cycle_swords_fx[i]
                    end
                end
                return nil
            end
            local function GetFreeSword_DOWN_NUM()
                local temp_num = 0
                for i = 1, max_sword_num, 1 do
                    if cycle_swords_fx[i].BUSY == false and not cycle_swords_fx[i].UP_FLAG then
                        temp_num = temp_num + 1
                    end
                end
                return temp_num
            end
        ----------------------------------------------------------------------------------------------------------------------------
        --- 添加/移除
            inst:ListenForEvent("add_sword_fx",function(inst,animover_fn)
                local free_sword = GetFreeSword_UP()
                if free_sword then
                    free_sword.BUSY = true
                    free_sword:PushEvent("join",function()
                        free_sword.BUSY = false
                        free_sword.UP_FLAG = false
                        if animover_fn then
                            animover_fn()
                        end
                    end)
                end
            end)
            inst:ListenForEvent("remove_sword_fx",function(inst,animover_fn)
                local free_sword = GetFreeSword_DOWN()
                if free_sword then
                    free_sword.BUSY = true
                    free_sword:PushEvent("leave",function()
                        free_sword.BUSY = false
                        free_sword.UP_FLAG = true
                        if animover_fn then
                            animover_fn()
                        end
                    end)
                end
            end)
            inst:ListenForEvent("leave_all_sword_fx",function(inst)
                for i = 1, max_sword_num, 1 do
                    inst:DoTaskInTime(i*0.2,function()
                        inst:PushEvent("remove_sword_fx")
                    end)
                end
            end)
        ----------------------------------------------------------------------------------------------------------------------------
        ---- 攻击目标
            local attacking_list = {} -- 做个列表
            local function Check_Can_Attack_Target(target)
                -- return true
                if attacking_list[target] ~= true
                    and ( target.components.health and not target.components.health:IsDead() )
                    and target.components.combat
                    and target.components.combat.target and target.components.combat.target:IsValid()
                    and target.components.combat.target:HasOneOfTags({"player","companion","structure","wall"})
                    and target.components.combat:CanBeAttacked(inst)
                    then
                        return true
                    end
                    return false
            end
            local function Check_Can_Attack_Target_Auto(target)
                -- return true
                if attacking_list[target] ~= true
                    and ( target.components.health and not target.components.health:IsDead() )
                    and target.components.combat and target.components.combat:CanBeAttacked(inst)
                    then
                        return true
                    end
                    return false
            end
            local function DoDamage2Target(target)
                if target and target.components.combat and target.components.combat:CanBeAttacked(inst) then
                    local dmg, spdmg = inst.components.combat:CalcDamage(target, sword_inst_for_dmg)
                    target.components.combat:GetAttacked(inst, dmg, sword_inst_for_dmg, nil, spdmg)
                end
            end

            local search_target_musthavetags = { "_combat" }
            local search_target_canthavetags = {"INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "player", "companion"}
            local search_target_musthaveoneoftags = nil


            inst:ListenForEvent("remove_sword_fx_for_target",function(inst,target)
                if not Check_Can_Attack_Target(target) then
                    return
                end
                local temp_aoe_flag = false
                if sword_inst_for_dmg_attack_num >= (TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 3 or 7) then
                    temp_aoe_flag = true
                end
                if not temp_aoe_flag then
                    --------------------------------------------------------------------------------------------------------------
                    ---- 单个攻击
                        if attacking_list[target] then
                            return
                        end
                        --- 先判断有没有空余的剑
                        if GetFreeSword_DOWN() == nil then
                            return
                        end
                        attacking_list[target] = true
                        inst:PushEvent("remove_sword_fx",function()
                            ----------------------------------------------------------------------------------------
                            ---- 单个目标
                                SpawnPrefab("sword_fairy_sfx_flying_sword_hit"):PushEvent("Set",{
                                    target = target,
                                    speed = 1.5,
                                    onhit_fn = function(sword_hit_fx)                                    
                                        sword_inst_for_dmg_update()
                                        DoDamage2Target(target)
                                    end,
                                    on_leave_fn = function(sword_hit_fx) --- 重新回到玩家身边
                                        if sword_surround_active_flag then
                                            inst:PushEvent("add_sword_fx")
                                            attacking_list[target] = nil
                                        end
                                    end,
                                })                        
                            ----------------------------------------------------------------------------------------
                        end)
                    --------------------------------------------------------------------------------------------------------------
                else
                    --------------------------------------------------------------------------------------------------------------
                    ---- AOE
                        ---- 先囤积3把剑
                        if GetFreeSword_DOWN_NUM() ~= max_sword_num then
                            return
                        end
                        ---- 移除3把，然后在其中一把挂上后续执行函数
                        inst:PushEvent("remove_sword_fx")
                        inst:PushEvent("remove_sword_fx")
                        inst:PushEvent("remove_sword_fx",function()
                            sword_inst_for_dmg_attack_num = 0
                            local x,y,z = target.Transform:GetWorldPosition()
                            SpawnPrefab("sword_fairy_sfx_flying_sword_hit"):PushEvent("Set",{
                                pt = Vector3(x,0,z),
                                speed = 1.5,
                                onhit_fn = function(sword_hit_fx)
                                    sword_hit_fx:Remove()
                                    SpawnPrefab("sword_fairy_sfx_flying_sword_aoe"):PushEvent("Set",{
                                        pt = Vector3(x,0.5,z),
                                        on_hit_fn = function()
                                            ------------------------------------------------------
                                            --- 寻找AOE目标并造成伤害
                                                sword_inst_for_dmg:AddTag("AOE")
                                                -- print("AOE_target +++++++++++++++++++++++++++++++ ")
                                                sword_inst_for_dmg_update(true)
                                                local ents = TheSim:FindEntities(x, y, z, 8, search_target_musthavetags, search_target_canthavetags, search_target_musthaveoneoftags)
                                                for _,temp_target in pairs(ents) do
                                                    DoDamage2Target(temp_target)
                                                    -- print("AOE_target",temp_target)
                                                    ---- 额外1%生命值上限的直伤
                                                        if temp_target.components.health and not temp_target.components.health:IsDead() then
                                                            local temp_health_max = temp_target.components.health.maxhealth
                                                            local temp_dmg = (temp_health_max/100)*1
                                                            if temp_dmg > 0 then
                                                                temp_target.components.health:DoDelta(-temp_dmg)
                                                            end
                                                        end
                                                end
                                                -- print("AOE_target +++++++++++++++++++++++++++++++ ")
                                                sword_inst_for_dmg:RemoveTag("AOE")
                                            ------------------------------------------------------
                                        end,
                                        animover_fn = function()
                                            ------------------------------------------------------
                                            -- 
                                                -- inst:PushEvent("add_sword_fx")
                                                attacking_list[target] = nil
                                            ------------------------------------------------------
                                            ---
                                                local leave_fx = SpawnPrefab("sword_fairy_sfx_sword_idle")
                                                leave_fx.Transform:SetPosition(x,y,z)
                                                leave_fx:PushEvent("leave",function()
                                                    leave_fx:Remove()
                                                    if sword_surround_active_flag then
                                                        inst:PushEvent("add_sword_fx")
                                                        inst:PushEvent("add_sword_fx")
                                                        inst:PushEvent("add_sword_fx")
                                                    end
                                                end)
                                            ------------------------------------------------------
                                        end,
                                    })
                                end,
                            })
                        end)
                    --------------------------------------------------------------------------------------------------------------
                end
            end)
        ----------------------------------------------------------------------------------------------------------------------------
        --- 自动寻找目标并攻击
            local Search_Target_And_Attack_CD_Task = nil

            local function Search_Target_And_Attack()
                if Search_Target_And_Attack_CD_Task ~= nil then
                    return
                end
                local x,y,z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, 20, search_target_musthavetags, search_target_canthavetags, search_target_musthaveoneoftags)
                -- print("target num",#ents)
                local cd_flag = false
                local delay_time = 0
                local delay_time_delta = 0.3
                for _,temp_target in pairs(ents) do
                    if Check_Can_Attack_Target_Auto(temp_target) then
                        inst:DoTaskInTime(delay_time,function()
                            inst:PushEvent("remove_sword_fx_for_target",temp_target)
                        end)
                        delay_time = delay_time + delay_time_delta
                        cd_flag = true
                    end
                end
                if cd_flag then
                    Search_Target_And_Attack_CD_Task = inst:DoTaskInTime( (TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 2 or 2)-0.5,function()
                        Search_Target_And_Attack_CD_Task = nil
                    end)
                end
            end
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
                    if not sword_surround_active_flag then
                        stop_mp_down_task()
                        inst:PushEvent("leave_all_sword_fx")
                        return
                    end

                    Search_Target_And_Attack()  --- 自动寻找目标

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
                    if MP <= 0 then
                        inst.components.sword_fairy_com_rpc_event:PushEvent("sword_fairy_spell.fail") -- 法力不足
                        return
                    end
                    start_mp_down_task()
                    sword_surround_active_flag = true
                   
                    inst:PushEvent("add_sword_fx")
                    inst:PushEvent("add_sword_fx")
                    inst:PushEvent("add_sword_fx")

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
            inst:ListenForEvent("onhitother",function(inst,_table)
                if not sword_surround_active_flag then
                    return
                end
                _table = _table or {}
                local target = _table.target
                local weapon = _table.weapon
                -- print("info ++ weapon",weapon)
                if weapon == sword_inst_for_dmg then
                    if not sword_inst_for_dmg:HasTag("AOE") then
                        sword_inst_for_dmg_attack_num = sword_inst_for_dmg_attack_num + 1
                        -- print("info ++",sword_inst_for_dmg_attack_num)
                    end
                    return
                end
                inst:PushEvent("remove_sword_fx_for_target",target)
            end)
        ----------------------------------------------------------------------------------------------------------------------------
        ---- 死亡取消激活
            inst:ListenForEvent("death",function()
                if not sword_surround_active_flag then
                    return
                end
                sword_surround_active_flag = false
                inst:PushEvent("leave_all_sword_fx")
            end)
        ----------------------------------------------------------------------------------------------------------------------------

        









    end)
end