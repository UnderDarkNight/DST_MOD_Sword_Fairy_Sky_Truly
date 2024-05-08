--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    法力值显示系统

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        local temp_name = "sword_fairy_spriter"
        return TUNING["sword_fairy_sky_truly.fn"].GetStringsTable(temp_name or prefab_name)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 基础界面API
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"

    local Badge = require "widgets/badge"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- MP 值显示界面
    local function setup_badge(inst,root)
        if inst.__container_widget_badge then
            inst.__container_widget_badge:Kill()
            inst.__container_widget_badge = nil
        end
        if ThePlayer.__test_hud then
            inst.__container_widget_badge = ThePlayer.__test_hud(inst,root)
            return
        end
        ------------------------------------------------------------------------------------------------------------------------------
        ----- 创建
            local MP_Badge = root:AddChild(Badge())
            root.MP_Badge = MP_Badge
            --------------------------------------------------------------------------------------------------------------------------
            ----- 坐标初始化
                MP_Badge:SetPosition(200,-180,0)
                local badge_scale = 1.5
                MP_Badge:SetScale(badge_scale,badge_scale,badge_scale)
            --------------------------------------------------------------------------------------------------------------------------
            ----- 颜色
                MP_Badge.anim:GetAnimState():SetMultColour(unpack({180 / 255, 210 / 255, 182 / 255, 1}))
            --------------------------------------------------------------------------------------------------------------------------
            ----- 进度条暂停
                MP_Badge.anim:GetAnimState():Pause()
                MP_Badge:SetPercent(0.5)
            --------------------------------------------------------------------------------------------------------------------------
            ------ 覆盖外框
                MP_Badge.circleframe:GetAnimState():OverrideSymbol("frame_circle", "sword_fairy_hud_status", "frame_circle")
            ------ 内部图案
                MP_Badge.__temp_fx = MP_Badge:AddChild(UIAnim())
                MP_Badge.__temp_fx:GetAnimState():SetBank("sword_fairy_hud_status")
                MP_Badge.__temp_fx:GetAnimState():SetBuild("sword_fairy_hud_status")
                MP_Badge.__temp_fx:GetAnimState():PlayAnimation("mp", true)
                MP_Badge.__temp_fx:GetAnimState():SetDeltaTimeMultiplier(0.2)
                local scale = 0.6
                MP_Badge.__temp_fx:SetScale(scale, scale, scale)
            ----- 数字前移                
                MP_Badge.num:MoveToFront()
                inst:DoTaskInTime(1,function()
                    pcall(function()
                        MP_Badge.maxnum:MoveToFront()                        
                    end)
                end)
            --------------------------------------------------------------------------------------------------------------------------
            ----- 参数初始化
                local function ParamInit()
                    local mp_current = inst.replica.sword_fairy_com_magic_point_sys:GetCurrent()
                    local mp_max = inst.replica.sword_fairy_com_magic_point_sys:GetMax()
                    local mp_percent = mp_current / mp_max
                    MP_Badge:SetPercent(mp_percent,mp_max)
                end
                ParamInit()
            --------------------------------------------------------------------------------------------------------------------------
            ----- 连接事件
                MP_Badge.inst:ListenForEvent("sword_fairy_mp_replica_data_refresh",ParamInit,inst)
        ------------------------------------------------------------------------------------------------------------------------------
        inst.__container_widget_badge = MP_Badge
    end
    local function remove_badge(inst)
        if inst.__container_widget_badge then
            inst.__container_widget_badge:Kill()
            inst.__container_widget_badge = nil
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("sword_fairy_event.container_widget_open", function(inst, container_widget_root)
            -- print("info container_widget_open",container_widget_root)
            setup_badge(inst,container_widget_root)
        end)
        
        inst:ListenForEvent("sword_fairy_event.container_widget_close", function(inst)
            -- print("info container_widget_close")
            remove_badge(inst)
        end)
    end

    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("sword_fairy_com_magic_point_sys")
    inst.components.sword_fairy_com_magic_point_sys.current = 7
    inst.components.sword_fairy_com_magic_point_sys.max = 7
    inst.components.sword_fairy_com_magic_point_sys.base_max = 7


    inst:ListenForEvent("linked_player",function(inst,owner)
        
    end)

end