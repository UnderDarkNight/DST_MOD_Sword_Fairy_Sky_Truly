--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    法力值、醉意值 安装

]] --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 坐标 读取 储存数据的API

    local function Get_Data_File_Name()
        return "SWORD_FAIRY_SKY_TRULY_DATA.TEXT"
    end
    local function Read_All_Json_Data()

        local function Read_data_p()
            local file = io.open(Get_Data_File_Name(), "r")
            local text = file:read('*line')
            file:close()
            return text
        end

        local flag, ret = pcall(Read_data_p)

        if flag == true then
            local retTable = json.decode(ret)
            return retTable
        else
            print("moonlightcoda_data ERROR :read cross archived data error : Read_All_Json_Data got nil")
            print(ret)
            return {}
        end
    end

    local function Write_All_Json_Data(json_data)
        local w_data = json.encode(json_data)
        local file = io.open(Get_Data_File_Name(), "w")
        file:write(w_data)
        file:close()
    end

    local function Get_Cross_Archived_Data_By_userid(userid)
        local crash_flag, all_data_table = pcall(Read_All_Json_Data)
        if crash_flag then
            local temp_json_data = all_data_table
            return temp_json_data[userid] or {}
        else
            print("error : Read_All_Json_Data fn crash")
            return {}
        end
    end

    local function Set_Cross_Archived_Data_By_userid(userid, _table)

        local temp_json_data = Read_All_Json_Data() or {}
        -- temp_json_data[userid] = _table
        temp_json_data[userid] = temp_json_data[userid] or {}
        for index, value in pairs(_table) do
            temp_json_data[userid][index] = value
        end
        temp_json_data = deepcopy(temp_json_data)
        -- Write_All_Json_Data(temp_json_data)
        pcall(Write_All_Json_Data, temp_json_data)
    end

    local function read_xy_percent()
        local data_table = {}
        local crash_flag, temp_table = pcall(Get_Cross_Archived_Data_By_userid, ThePlayer.userid)
        if crash_flag then
            data_table = temp_table
        end

        local x, y = data_table.x or 0.05, data_table.y or 0.93
        return x, y
    end
    local function save_xy_percent(x, y)
        local data_table = {
            x = x,
            y = y
        }
        pcall(Set_Cross_Archived_Data_By_userid, ThePlayer.userid, data_table)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装数据更新event
    local function badge_update_event_setup(inst,root,MP_Badge,Drunkenness_Badge)
        
        -- MP_Badge.anim:GetAnimState():SetPercent("anim",0.5)
        MP_Badge:SetPercent(0.5,7)
        -- Drunkenness_Badge.anim:GetAnimState():Pause()
        -- Drunkenness_Badge.anim:GetAnimState():SetPercent("anim",0.5)
        -- Drunkenness_Badge:SetPercent(0.5,44)
        -------------------------------------------------------------
        --- 法力值
            local mp = inst.replica.sword_fairy_com_magic_point_sys:GetCurrent()
            local mp_max = inst.replica.sword_fairy_com_magic_point_sys:GetMax()
            MP_Badge:SetPercent(mp/mp_max,mp_max)
            inst.replica.sword_fairy_com_magic_point_sys:AddUpdateFn(function(inst,current,max,percent)
                MP_Badge:SetPercent(percent,max)
                root:LocationScaleFix()
            end)
        -------------------------------------------------------------
        --- 醉意值
            local drunkenness = inst.replica.sword_fairy_com_drunkenness:GetCurrent()
            local drunkenness_max = inst.replica.sword_fairy_com_drunkenness:GetMax()
            Drunkenness_Badge:SetPercent(drunkenness/drunkenness_max,drunkenness_max)
            inst.replica.sword_fairy_com_drunkenness:AddUpdateFn(function(inst,current,max,percent)
                Drunkenness_Badge:SetPercent(percent,max)
                root:LocationScaleFix()
            end)
        -------------------------------------------------------------




    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0, function()
        if inst ~= ThePlayer then
            return
        end

        if ThePlayer.HUD == nil then
            return
        end

        local root = ThePlayer.HUD.controls.status:AddChild(Widget())
        ThePlayer.HUD.controls.status.sword_fairy_hud_status = root
        -------------------------------------------------------------------------------------
        --- 设置基点，缩放模式
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(0, 0)
            -- root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
        -------------------------------------------------------------------------------------
        --- 坐标初始化
            root.x_percent,root.y_percent = read_xy_percent()
            function root:LocationScaleFix()
                if self.x_percent and not self.__mouse_holding  then
                    local scrnw, scrnh = TheSim:GetScreenSize()
                    if self.____last_scrnh ~= scrnh then
                        local tarX = self.x_percent * scrnw
                        local tarY = self.y_percent * scrnh
                        self:SetPosition(tarX,tarY)
                    end
                    self.____last_scrnh = scrnh
                end
            end
            root:LocationScaleFix()
            inst:DoPeriodicTask(5,function()
                root:LocationScaleFix()                            
            end)
        -------------------------------------------------------------------------------------
        --- MP值
            local MP_Badge = root:AddChild(Badge())
            root.MP_Badge = MP_Badge
            ----- 颜色
                MP_Badge.anim:GetAnimState():SetMultColour(unpack({180 / 255, 210 / 255, 182 / 255, 1}))
            ----- 进度条暂停
                MP_Badge.anim:GetAnimState():Pause()
                MP_Badge:SetPercent(0.5)
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
        ---------------------------------------------------------------------------------
        ---- 按钮移动事件
            MP_Badge.__temp_old_OnMouseButton = MP_Badge.OnMouseButton
            MP_Badge.OnMouseButton = function(self, button, down, x, y)
                if down then
                    --------------------------------------------------------------
                    if not root.__mouse_holding then
                        root.__mouse_holding = true --- 上锁
                        --------- 添加鼠标移动监听任务
                        root.___follow_mouse_event = TheInput:AddMoveHandler(function(x, y)
                            root:SetPosition(x, y, 0)
                        end)
                        --------- 添加鼠标按钮监听
                        root.___mouse_button_up_event = TheInput:AddMouseButtonHandler(function(button, down, x, y)
                            if button == MOUSEBUTTON_LEFT and down == false then ---- 左键被抬起来了
                                root.___mouse_button_up_event:Remove() ---- 清掉监听
                                root.___mouse_button_up_event = nil

                                root.___follow_mouse_event:Remove() ---- 清掉监听
                                root.___follow_mouse_event = nil

                                root:SetPosition(x, y, 0) ---- 设置坐标
                                root.__mouse_holding = false ---- 解锁

                                local scrnw, scrnh = TheSim:GetScreenSize()
                                root.x_percent = x / scrnw
                                root.y_percent = y / scrnh

                                ------------------------------------------------------------------------
                                ----
                                save_xy_percent(root.x_percent,root.y_percent)  ---- 储存坐标
                                ------------------------------------------------------------------------

                            end
                        end)
                    end
                    --------------------------------------------------------------
                end
                return self.__temp_old_OnMouseButton(self, button, down, x, y)
            end
        ---------------------------------------------------------------------------------
        -------------------------------------------------------------------------------------
        --- 醉意值
            local Drunkenness_Badge = root:AddChild(Badge())
            root.Drunkenness_Badge = Drunkenness_Badge

            ----- 颜色
                Drunkenness_Badge:SetPosition(-60,0)
                Drunkenness_Badge.anim:GetAnimState():SetMultColour(unpack({202/255,180/255,110/255,1}))
            ----- 进度条暂停
                Drunkenness_Badge.anim:GetAnimState():Pause()
                Drunkenness_Badge:SetPercent(0.5)
            ------ 覆盖外框
                Drunkenness_Badge.circleframe:GetAnimState():OverrideSymbol("frame_circle","sword_fairy_hud_status","frame_circle")
            ------ 内部图案
                Drunkenness_Badge.__temp_fx = Drunkenness_Badge:AddChild(UIAnim())
                Drunkenness_Badge.__temp_fx:GetAnimState():SetBank("sword_fairy_hud_status")
                Drunkenness_Badge.__temp_fx:GetAnimState():SetBuild("sword_fairy_hud_status")
                Drunkenness_Badge.__temp_fx:GetAnimState():PlayAnimation("wine",true)
                -- MP_Badge.__temp_fx:GetAnimState():SetDeltaTimeMultiplier(0.2)
                local scale = 0.6
                Drunkenness_Badge.__temp_fx:SetScale(scale,scale,scale)
            ----- 数字前移
                Drunkenness_Badge.num:MoveToFront()
                inst:DoTaskInTime(1,function()
                    pcall(function()
                        Drunkenness_Badge.maxnum:MoveToFront()                        
                    end)
                end)
        -------------------------------------------------------------------------------------
            badge_update_event_setup(inst,root,MP_Badge,Drunkenness_Badge)
        -------------------------------------------------------------------------------------

    end)

    if TheWorld.ismastersim then
        inst:DoTaskInTime(1,function()
            inst.components.sword_fairy_com_drunkenness:DoDeltaMax(0)
            inst.components.sword_fairy_com_magic_point_sys:DoDeltaMax(0)
        end)
    end
end
