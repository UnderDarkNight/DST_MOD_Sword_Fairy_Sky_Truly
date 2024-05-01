--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



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
                    return
                end
                local ret = data:Add("flying_sword",1)
                cycle_fx:PushEvent("sword",{
                    num = ret,
                    fn = function(sword_fx)
                        sword_fx:PushEvent("join")
                    end
                })
            end)
            
            inst:ListenForEvent("remove_sword_fx",function()
                local current = data:Add("flying_sword",0)
                if current <= 0 then
                    return
                end
                local ret = data:Add("flying_sword",-1)
                cycle_fx:PushEvent("sword",{
                    num = current,
                    fn = function(sword_fx)
                        sword_fx:PushEvent("leave")
                    end,
                })
            end)
            ----------------------------------------------------------------------------------------------------------------------
            ---- 移除剑并攻击目标
                inst:ListenForEvent("remove_sword_fx_for_target",function(inst,target)
                    local current = data:Add("flying_sword",0)
                    if current <= 0 then
                        return
                    end
                    local ret = data:Add("flying_sword",-1)
                    cycle_fx:PushEvent("sword",{
                        num = current,
                        fn = function(sword_fx)
                            sword_fx:PushEvent("up",function(sword_fx)
                                sword_fx:Hide()
                                ---------------------------------------------------
                                ---------------------------------------------------
                                --- 开始往目标身上戳
                                    SpawnPrefab("sword_fairy_sfx_flying_sword_hit"):PushEvent("Set",{
                                        target = target,
                                        speed = 1.5,
                                        fn = function()
                                            -- if target.components.health then
                                            --     target.components.health:DoDelta(-1000)
                                            -- end
                                            if target.components.combat then
                                                -- target.components.combat:GetAttacked
                                                inst.components.combat:DoAttack(target,sword_inst_for_dmg) --- 玩家使用特定武器inst攻击目标
                                            end
                                        end
                                    })
                                ---------------------------------------------------
                            end)
                        end,
                    })
                end)
            ----------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------
        --- 武器触发
            inst:ListenForEvent("sword_fairy_weapon_flying_sword.equip",function(inst)
                inst:PushEvent("show_current_sword_fx")
            end)
            inst:ListenForEvent("sword_fairy_weapon_flying_sword.unequip",function(inst)
                inst:PushEvent("leave_all_sword_fx")
            end)
            if inst.components.inventory:EquipHasTag("sword_fairy_weapon_flying_sword") then
                inst:PushEvent("show_current_sword_fx")
            end
        ----------------------------------------------------------------------------------------------------------------------------
        --- 飞剑攻击触发。  屯满就开始逐个消耗
            -- local cost_sword_flag = false
            local cd_task = nil

            local cost_sword_flag = data:Add("flying_sword",0) >= max_sword_num
            inst:ListenForEvent("flying_sword_on_hit_target",function(inst,_table)
                if cd_task ~= nil then
                    return
                end
                if not cost_sword_flag then
                    ---- 开始囤积飞剑
                        inst:PushEvent("add_sword_fx")
                        local current = data:Add("flying_sword",0)
                        if current >= max_sword_num then
                            cost_sword_flag = true
                            cd_task = inst:DoTaskInTime(3,function() cd_task = nil end) --- 冷却一会
                        end
                else
                    ---- 开始消耗飞剑
                        -- local target = _table.target
                        -- inst:PushEvent("remove_sword_fx")
                        inst:PushEvent("remove_sword_fx_for_target",_table.target)
                        local current = data:Add("flying_sword",0)
                        if current <= 0 then
                            cost_sword_flag = false
                            cd_task = inst:DoTaskInTime(5,function() cd_task = nil end) --- 冷却一会
                        end
                end

            end)
        ----------------------------------------------------------------------------------------------------------------------------

        









    end)
end