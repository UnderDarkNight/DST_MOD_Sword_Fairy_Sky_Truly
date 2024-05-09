local assets =
{
    Asset("ANIM", "anim/sword_fairy_spriter.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------
--- 获取环绕坐标
    local function GetRandomIdlePt(mid_pt,range)
        local function GetSurroundPoints(CMD_TABLE)
            -- local CMD_TABLE = {
            --     target = inst or Vector3(),
            --     range = 8,
            --     num = 8
            -- }
            if CMD_TABLE == nil then
                return
            end
            local theMid = nil
            if CMD_TABLE.target == nil then
                theMid = Vector3( self.inst.Transform:GetWorldPosition() )
            elseif CMD_TABLE.target.x then
                theMid = CMD_TABLE.target
            elseif CMD_TABLE.target.prefab then
                theMid = Vector3( CMD_TABLE.target.Transform:GetWorldPosition() )
            else
                return
            end   
            local num = CMD_TABLE.num or 8
            local range = CMD_TABLE.range or 8
            local retPoints = {}
            for i = 1, num, 1 do
                local tempDeg = (2*PI/num)*(i-1)
                local tempPoint = theMid + Vector3( range*math.cos(tempDeg) ,  0  ,  range*math.sin(tempDeg)    )
                table.insert(retPoints,tempPoint)
            end    
            return retPoints    
        end
        local ret_points = GetSurroundPoints({
            target = mid_pt,
            range = range,
            num = 15
        }) or {}
        if #ret_points == 0 then
            return nil
        end
        return ret_points[math.random(#ret_points)]
    end
----------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "sword_fairy_spriter_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos = {},
                    animbank = "ui_fish_box_5x4",
                    animbuild = "ui_fish_box_5x4",
                    pos = Vector3(0, 220, 0),
                    side_align_tip = 160,
                },
                type = "chest",
                acceptsstacks = true,                
            }

            for y = 2.5, -0.5, -1 do
                for x = -1, 3 do
                    table.insert(params[container_widget_name].widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
                end
            end
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    return true
                end
            ------------------------------------------------------------------------------------------

            ------------------------------------------------------------------------------------------
        end
        
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音
            -- if theContainer.widget then
            --     theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
            --     theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
            -- end
        ------------------------------------------------------------------------
    end

    local function add_container_before_not_ismastersim_return(inst)
        -------------------------------------------------------------------------------------------------
        ------ 添加背包container组件    --- 必须在 SetPristine 之后，
        -- local container_WidgetSetup = "wobysmall"
        if TheWorld.ismastersim then
            inst:AddComponent("container")
            -- inst.components.container.openlimit = 1  ---- 限制1个人打开
            -- inst.components.container:WidgetSetup(container_WidgetSetup)
            container_Widget_change(inst.components.container)

        else
            inst.OnEntityReplicated = function(inst)
                container_Widget_change(inst.replica.container)

                -----------------------------------------
                --- 限制指定玩家打开
                    local old_AddOpener_fn = inst.replica.container.AddOpener
                    inst.replica.container.AddOpener = function(self,opener)
                        if opener and opener == self.inst.__link_player:value() then
                            old_AddOpener_fn(self,opener)
                        end
                    end
                -----------------------------------------
            end
        end
        -------------------------------------------------------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------------------
----
    local function other_key_modules_init(inst)
        local main_modules_init_fn = require("prefabs/06_pets/spriter_key_modules/00_main")
		if type(main_modules_init_fn) == "function" then
			main_modules_init_fn(inst)
		end
    end
----------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("sword_fairy_spriter")
    inst.AnimState:SetBuild("sword_fairy_spriter")
    inst.AnimState:PlayAnimation("idle",true)

    -- inst.fx = inst:SpawnChild("cane_candy_fx")
    inst:AddTag("NOBLOCK")
    
    inst.entity:SetPristine()
    ---------------------------------------------------------------------------------------------
    ---
        if TheWorld.ismastersim then
            inst:AddComponent("sword_fairy_com_data")
        end
    ---------------------------------------------------------------------------------------------
    --- 玩家link
        inst.__link_player = net_entity(inst.GUID,"sword_fairy_spriter_link","sword_fairy_spriter_link")
        inst.GetLinkedPlayer = function(inst)
            if TheWorld.ismastersim then
                return inst.linked_player or inst.__link_player:value()
            end
            return inst.__link_player:value()
        end
        inst:ListenForEvent("sword_fairy_spriter_link",function(inst)    --- 反向链接玩家
            local linked_player = inst:GetLinkedPlayer()
            if linked_player then
                linked_player.___spriter = inst
            end
        end)
    ---------------------------------------------------------------------------------------------
    --- 安装容器
        add_container_before_not_ismastersim_return(inst)
    ---------------------------------------------------------------------------------------------
    --- 其他机制模块
        other_key_modules_init(inst)
    ---------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ---------------------------------------------------------------------------------------------
    --- 容器开关
        inst:ListenForEvent("onopen",function(inst)
            inst:AddTag("spriter_opened")
        end)
        inst:ListenForEvent("onclose",function(inst)
            inst:RemoveTag("spriter_opened")
        end)
    ---------------------------------------------------------------------------------------------
    ----- 移动控制API
        function inst:Close2Point(pt,speed)
            self:FacePoint(pt.x,0,pt.z)
            self.Physics:ClearCollidesWith(COLLISION.LIMITS)
            self.Physics:SetMotorVel(speed, 0, 0)
            self.current_speed = speed
        end
        function inst:Close2Point_Soft(pt,tar_speed)
            local speed = 0
            if self.current_speed and self.speed_soft_delta then
                local delta_speed = math.abs(tar_speed - self.current_speed) / self.speed_soft_delta
                if self.current_speed < tar_speed then
                    speed = self.current_speed + delta_speed
                else
                    speed = self.current_speed - delta_speed
                end
                -- if tar_speed < self.current_speed then
                --     speed = self.current_speed + self.speed_soft_delta
                -- else
                --     speed = self.current_speed - self.speed_soft_delta
                -- end
            else
                speed = tar_speed
            end

            self:FacePoint(pt.x,0,pt.z)
            self.Physics:ClearCollidesWith(COLLISION.LIMITS)
            self.Physics:SetMotorVel(speed, 0, 0)
            self.current_speed = speed
        end
        function inst:StopClosing()
            inst.Physics:Stop()
        end
    ---------------------------------------------------------------------------------------------
    --- 常用交互
        inst:AddComponent("inspectable")
    ---------------------------------------------------------------------------------------------



    ---------------------------------------------------------------------------------------------
    --- 参数表配置连接玩家
        inst:ListenForEvent("Set",function(inst,_table)
            _table = _table or {
                target = nil,
                pt = Vector3(0,0,0),
                speed = TUNING.WILSON_RUN_SPEED,
                HitDist = 5,
            }
            -----------------------------------------------------------
            --
                if _table.target == nil then
                    inst:Remove()
                    return
                end
            -----------------------------------------------------------
            --
                inst.Transform:SetPosition(_table.pt.x,0,_table.pt.z)
            -----------------------------------------------------------
            --  参数表
                local HitDist = _table.HitDist or 5         --- 跟随玩家的距离
                local HitDist_SQ = HitDist*HitDist          --- 跟随玩家的距离平方
                local Idle_Dist = HitDist - 1.5               --- 随机移动距离
                local Idle_Dist_SQ = Idle_Dist*Idle_Dist    --- 随机移动距离平方
                local Idle_CD_Task = nil
                local owner = _table.target
                local speed = _table.speed or TUNING.WILSON_RUN_SPEED

            -----------------------------------------------------------
            --  连接玩家
                inst.__link_player:set(owner)
                inst.linked_player = owner
            -----------------------------------------------------------
            --  追着目标跑
                if inst.__follow_task then
                    inst.__follow_task:Cancel()
                end
                inst.__follow_task = inst:DoPeriodicTask(FRAMES*5,function()                
                    if inst:GetDistanceSqToInst(_table.target) <= HitDist_SQ then 
                        ---------------------------------------------------------------------
                        --- 停止并面向玩家
                            -- inst:StopClosing()
                            -- inst:ForceFacePoint(owner.Transform:GetWorldPosition())
                        ---------------------------------------------------------------------
                        --- 容器打开就停止移动
                            if inst:HasTag("spriter_opened") then
                                inst:StopClosing()
                                inst:ForceFacePoint(owner.Transform:GetWorldPosition())
                                return
                            end
                        ---------------------------------------------------------------------
                        --- 随机移动
                            if inst._idle_target_pt == nil then
                                inst._idle_target_pt = GetRandomIdlePt(owner,Idle_Dist)
                            else
                                if inst:GetDistanceSqToPoint(inst._idle_target_pt.x,0,inst._idle_target_pt.z) < Idle_Dist_SQ then
                                    inst._idle_target_pt = nil
                                    Idle_CD_Task = inst:DoTaskInTime(math.random(3,10),function()
                                        Idle_CD_Task = nil
                                    end)
                                else
                                    if Idle_CD_Task ~= nil then
                                        inst:StopClosing()
                                        if math.random(1000) < 50 then
                                            inst:ForceFacePoint(owner.Transform:GetWorldPosition())
                                        end
                                    else
                                        inst:Close2Point(inst._idle_target_pt,speed*0.4)
                                    end
                                end
                            end
                        ---------------------------------------------------------------------
                        --- 特效处理
                            -- if inst.fx then
                            --     inst.fx:Remove()
                            --     inst.fx = nil
                            -- end
                            inst:PushEvent("stop_fx")
                        ---------------------------------------------------------------------
                    else
                        ---------------------------------------------------------------------
                        --- 清除 idle 状态的一些任务和参数
                            inst._idle_target_pt = nil
                            if Idle_CD_Task then
                                Idle_CD_Task:Cancel()
                                Idle_CD_Task = nil
                            end
                        ---------------------------------------------------------------------
                        inst:Close2Point(Vector3(owner.Transform:GetWorldPosition()),speed)
                        -- if inst.fx == nil then
                        --     inst.fx = inst:SpawnChild("cane_candy_fx")
                        --     inst.fx.Transform:SetPosition(-0.5,1.5,0)
                        -- end
                        inst:PushEvent("start_fx")
                    end
                end)
            -----------------------------------------------------------

            inst:PushEvent("linked_player",owner)
            inst.Ready = true
        end)
    ---------------------------------------------------------------------------------------------
    --- 
        inst:ListenForEvent("ClosePlayer",function()
            if inst.linked_player then
                local offset_pt = Vector3(math.random(10,25) * (math.random()<0.5 and 1 or -1) , 0 ,   math.random(10,25) * (math.random()<0.5 and 1 or -1)  )
                local player_pt = Vector3(inst.linked_player.Transform:GetWorldPosition())
                inst.Transform:SetPosition(player_pt.x + offset_pt.x , 0 , player_pt.z + offset_pt.z)
            end
        end)
    ---------------------------------------------------------------------------------------------
    ---
        inst:DoTaskInTime(0,function()
            if not inst.Ready then
                inst:Remove()
            end
        end)
    ---------------------------------------------------------------------------------------------
    ----
        inst:PushEvent("master_post_init")
    ---------------------------------------------------------------------------------------------


    return inst
end


return Prefab("sword_fairy_spriter", fn, assets)