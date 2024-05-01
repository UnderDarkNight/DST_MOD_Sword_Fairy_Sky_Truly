
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------
            -- -- ThePlayer.HUD.controls.status
            
            -- if ThePlayer.___test_hud then
            --     ThePlayer.___test_hud:Kill()
            -- end

            -- local root = ThePlayer.HUD.controls.status:AddChild(Widget())

            -- ThePlayer.___test_hud = root

            -- -------------------------------------------------------------------------------------

            --     root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            --     root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            --     root:SetPosition(1000,500)
            --     -- root:MoveToBack()
            --     root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            -- -------------------------------------------------------------------------------------
            -- --- MP值
            --     ----- 颜色
            --         local MP_Badge = root:AddChild(Badge())
            --         MP_Badge.anim:GetAnimState():SetMultColour(unpack({180/255,210/255,182/255,1}))
            --     ----- 进度条暂停
            --         MP_Badge.anim:GetAnimState():Pause()
            --         MP_Badge:SetPercent(0.5)
            --     ------ 覆盖外框
            --         MP_Badge.circleframe:GetAnimState():OverrideSymbol("frame_circle","sword_fairy_hud_status","frame_circle")
            --     ------ 内部图案
            --         MP_Badge.__temp_fx = MP_Badge:AddChild(UIAnim())
            --         MP_Badge.__temp_fx:GetAnimState():SetBank("sword_fairy_hud_status")
            --         MP_Badge.__temp_fx:GetAnimState():SetBuild("sword_fairy_hud_status")
            --         MP_Badge.__temp_fx:GetAnimState():PlayAnimation("mp",true)
            --         MP_Badge.__temp_fx:GetAnimState():SetDeltaTimeMultiplier(0.2)
            --         local scale = 0.6
            --         MP_Badge.__temp_fx:SetScale(scale,scale,scale)
            --     ----- 数字处理
            --         MP_Badge.num:MoveToFront()
            --         if MP_Badge.maxnum and MP_Badge.maxnum.MoveToFront then
            --             MP_Badge.maxnum:MoveToFront()
            --         end
            --     ---------------------------------------------------------------------------------
            --     ---- 按钮移动事件
            --         MP_Badge.__temp_old_OnMouseButton = MP_Badge.OnMouseButton
            --         MP_Badge.OnMouseButton = function(self,button, down, x, y)                
            --             if down then
            --                 --------------------------------------------------------------
            --                 if not root.__mouse_holding  then
            --                     root.__mouse_holding = true      --- 上锁
            --                         --------- 添加鼠标移动监听任务
            --                         root.___follow_mouse_event = TheInput:AddMoveHandler(function(x, y)  
            --                             root:SetPosition(x,y,0)
            --                         end)
            --                         --------- 添加鼠标按钮监听
            --                         root.___mouse_button_up_event = TheInput:AddMouseButtonHandler(function(button, down, x, y) 
            --                             if button == MOUSEBUTTON_LEFT and down == false then    ---- 左键被抬起来了
            --                                 root.___mouse_button_up_event:Remove()       ---- 清掉监听
            --                                 root.___mouse_button_up_event = nil
            
            --                                 root.___follow_mouse_event:Remove()          ---- 清掉监听
            --                                 root.___follow_mouse_event = nil
            
            --                                 root:SetPosition(x,y,0)                      ---- 设置坐标
            --                                 root.__mouse_holding = false                 ---- 解锁
            
            --                                 local scrnw, scrnh = TheSim:GetScreenSize()
            --                                 root.x_percent = x/scrnw
            --                                 root.y_percent = y/scrnh
            
            --                                 ------------------------------------------------------------------------
            --                                 ----
            --                                     -- save_xy_percent(root.x_percent,root.y_percent)  ---- 储存坐标
            --                                 ------------------------------------------------------------------------
            
            
            --                             end
            --                         end)
            --                 end
            --                 --------------------------------------------------------------
            --             end                
            --             return self.__temp_old_OnMouseButton(self,button, down, x, y)
            --         end
            --     ---------------------------------------------------------------------------------
            -- -------------------------------------------------------------------------------------
            -- --- 醉意值
            --     ----- 颜色
            --         local Drunkenness_Badge = root:AddChild(Badge())
            --         Drunkenness_Badge:SetPosition(-60,0)
            --         Drunkenness_Badge.anim:GetAnimState():SetMultColour(unpack({202/255,180/255,110/255,1}))
            --     ----- 进度条暂停
            --         Drunkenness_Badge.anim:GetAnimState():Pause()
            --         Drunkenness_Badge:SetPercent(0.5)
            --     ------ 覆盖外框
            --         Drunkenness_Badge.circleframe:GetAnimState():OverrideSymbol("frame_circle","sword_fairy_hud_status","frame_circle")
            --     ------ 内部图案
            --         Drunkenness_Badge.__temp_fx = Drunkenness_Badge:AddChild(UIAnim())
            --         Drunkenness_Badge.__temp_fx:GetAnimState():SetBank("sword_fairy_hud_status")
            --         Drunkenness_Badge.__temp_fx:GetAnimState():SetBuild("sword_fairy_hud_status")
            --         Drunkenness_Badge.__temp_fx:GetAnimState():PlayAnimation("wine",true)
            --         -- MP_Badge.__temp_fx:GetAnimState():SetDeltaTimeMultiplier(0.2)
            --         local scale = 0.6
            --         Drunkenness_Badge.__temp_fx:SetScale(scale,scale,scale)
            --     ----- 数字处理
            --         Drunkenness_Badge.num:MoveToFront()
            --         if Drunkenness_Badge.maxnum and Drunkenness_Badge.maxnum.MoveToFront then
            --             Drunkenness_Badge.maxnum:MoveToFront()
            --         end
            -- -------------------------------------------------------------------------------------



    ----------------------------------------------------------------------------------------------------------------
    ---- 环绕特效

        -- ThePlayer:PushEvent("add_sword_fx")
        -- ThePlayer:PushEvent("remove_sword_fx")

            ThePlayer.test_fn = function(target)
                SpawnPrefab("sword_fairy_sfx_flying_sword_hit"):PushEvent("Set",{
                    target = target,
                    -- speed = 3,
                })
            end

    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))