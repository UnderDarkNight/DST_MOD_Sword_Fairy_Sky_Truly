--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    minerhatlight 

    矿工帽 慢耐久 能量  一天（480s）。
    
    开灯 每秒消耗  7/480

    半径为 提灯 3倍

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------------------------
    --- 基础开关灯
        local light_fx = nil
        local function light_on()
            if light_fx then
                return
            end
            light_fx = inst:SpawnChild("minerhatlight")
            light_fx.Light:SetFalloff(0.4)
            light_fx.Light:SetIntensity(.7)
            light_fx.Light:SetRadius(5)
            light_fx.Light:SetColour(100 / 255, 255 / 255, 255 / 255)
        end
        local function light_off()
            if light_fx then
                light_fx:Remove()
                light_fx = nil
            end
        end
    ----------------------------------------------------------------------------------------------------
    ---- 
        local mp_cost_task = nil
        local mp_cost_per_sec = 7/480
        -- if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
        --     mp_cost_per_sec = 0
        -- end
        local function light_off_with_mp_cost()
            -- print("info light_off_with_mp_cost")
            if not mp_cost_task then
                return
            end
            mp_cost_task:Cancel()
            mp_cost_task = nil
            light_off()
        end
        local function light_on_with_mp_cost()
            -- print("info light_on_with_mp_cost")
            if mp_cost_task then
                return
            end
            if inst.components.sword_fairy_com_magic_point_sys:GetCurrent() <= 0 then   --- 没MP取消任务
                return
            end
            if inst:HasTag("spriter_hat_active") then    --- hat激活状态取消任务
                return
            end

            mp_cost_task = inst:DoPeriodicTask(1, function()
                -------------------------------------------------------------------------------------
                --- 检查是否需要关闭
                    local need_2_turn_off_light_flag = false
                    if not TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                        if inst.components.sword_fairy_com_magic_point_sys:GetCurrent() <= 0 then   --- 没MP取消任务
                            need_2_turn_off_light_flag = true
                        end
                        if TheWorld.state.isday and not TheWorld:HasTag("cave")  then    --- 白天取消任务
                            need_2_turn_off_light_flag = true
                        end
                    end
                    if inst:HasTag("spriter_hat_active") then    --- hat激活状态取消任务
                        need_2_turn_off_light_flag = true
                    end
                    if need_2_turn_off_light_flag then
                        light_off_with_mp_cost()
                        -- print("+++ spriter light off by task flag need_2_turn_off_light_flag")
                        return
                    end
                -------------------------------------------------------------------------------------

                inst.components.sword_fairy_com_magic_point_sys:DoDelta(-mp_cost_per_sec)
                if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
                    print("info light on with mp cost",inst.components.sword_fairy_com_magic_point_sys:GetCurrent())
                end
            end)

            light_on()

            inst:Say_With_Index("say.light_on")
        end
    ----------------------------------------------------------------------------------------------------
    ---
        inst:ListenForEvent("force_light_on_with_mp_cost",function(inst)
            light_on_with_mp_cost()
        end)
        inst:ListenForEvent("force_light_off_with_mp_cost",function(inst)
            light_off_with_mp_cost()
        end)
    ----------------------------------------------------------------------------------------------------
    --- 初始化检查，入夜检查
        local function light_on_common_switch_fn(time)
            inst:DoTaskInTime( type(time) == "number" and time or 5, function()
                if ( TheWorld.state.isnight and not TheWorld.state.isfullmoon ) or TheWorld:HasTag("cave") then
                    light_on_with_mp_cost()
                else
                    light_off_with_mp_cost()
                end
            end)
        end
        light_on_common_switch_fn()
        inst:WatchWorldState("isnight",light_on_common_switch_fn)
        inst:ListenForEvent("eat_food",light_on_common_switch_fn)
    ----------------------------------------------------------------------------------------------------
    --- 附身
        inst:ListenForEvent("spriter_hat_active",function(inst)
            light_off_with_mp_cost()
        end)
        inst:ListenForEvent("spriter_hat_inactive",function(inst)
            light_on_common_switch_fn(1)
        end)
    ----------------------------------------------------------------------------------------------------


end