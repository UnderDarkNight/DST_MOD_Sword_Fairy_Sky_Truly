
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

            -- ThePlayer.test_fn = function(target)
            --     SpawnPrefab("sword_fairy_sfx_flying_sword_hit"):PushEvent("Set",{
            --         target = target,
            --         -- speed = 3,
            --     })
            -- end
            -- print(ThePlayer.components.sword_fairy_com_data:Get("sword_num"))
            -- ThePlayer:PushEvent("add_sword_fx")

            -- local cycle_swords_fx = ThePlayer.cycle_fx.sword
            -- for i = 1, 3, 1 do
            --     -- cycle_swords_fx[i]:Show()                
            --     -- cycle_swords_fx[i]:PushEvent("down")
            --     print("BUSY",cycle_swords_fx[i].BUSY,"UP",cycle_swords_fx[i].UP_FLAG)
            -- end
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- ThePlayer.components.sword_fairy_com_magic_point_sys.max = 100
        -- ThePlayer.components.sword_fairy_com_magic_point_sys.current = 100
        -- ThePlayer.components.sword_fairy_com_magic_point_sys:SetPercent(1)
        -- print(ThePlayer.replica.sword_fairy_com_magic_point_sys:GetCurrent())
        -- print(ThePlayer.replica.sword_fairy_com_magic_point_sys:GetMax())
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
        -- for veggie, veggie_data in pairs(PLANT_DEFS) do
        --     print(veggie_data.prefab)
        -- end
        -- ThePlayer.components.sword_fairy_com_drunkenness:DoDelta(10)
    ----------------------------------------------------------------------------------------------------------------
    ----

        -- local book = TheSim:FindFirstEntityWithTag("sword_fairy_book_encyclopedia")
        -- -- ThePlayer.components.playercontroller:StartAOETargetingUsing(book)

        -- -- local active_spell_book = ThePlayer.components.playercontroller:GetActiveSpellBook()
        -- -- print("active_spell_book",active_spell_book)

        -- if ThePlayer.test_root then
        --     ThePlayer.test_root:Kill()
        -- end
        -- ThePlayer.test_root = nil
        -- ThePlayer.test_fn666 = function(book)
        --     -- print("test_llll+++")
        --     -- ThePlayer.components.playercontroller:StartAOETargetingUsing(book)
        --     if ThePlayer.test_root then
        --         ThePlayer.test_root:Kill()
        --     end
        --     ThePlayer.test_root = ThePlayer.HUD:AddChild(Widget())
        --     local front_root = ThePlayer.test_root
        --     local function close_widget()
        --         ThePlayer.test_root:Kill()
        --         ThePlayer.test_root = nil
        --     end
        --     --------------------------------------------------------------------------------------------
        --     ----

        --     --------------------------------------------------------------------------------------------
        --     -------- 设置锚点
        --         front_root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        --         front_root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        --         front_root:SetPosition(0,0)
        --         front_root:MoveToBack()
        --         front_root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        --     --------------------------------------------------------------------------------------------
        --     ----
        --         local root = front_root:AddChild(Widget())
        --     --------------------------------------------------------------------------------------------
        --     ----
        --         local scale = 0.6
        --     --------------------------------------------------------------------------------------------
        --     ---- 按钮创建统一API
        --         local function CreateButton(image,x,y,unlocked,fn)
        --             local ret_image = image..".tex"
        --             local temp_button = root:AddChild(ImageButton(
        --                 "images/widgets/sword_fairy_book_encyclopedia_ui.xml",
        --                 ret_image,ret_image,ret_image,ret_image,ret_image
        --             ))
        --             temp_button:SetScale(scale,scale,scale)
        --             temp_button:SetPosition(x or 0,y or 0)
        --             if not unlocked then
        --                 fn = function() end
        --             end
        --             temp_button.__old_t_temp_OnMouseButton = temp_button.OnMouseButton
        --             temp_button.OnMouseButton = function(self,button,down,x,y)
        --                 local ret = self:__old_t_temp_OnMouseButton(button,down,x,y)
        --                 if button == MOUSEBUTTON_LEFT and down == false then
        --                     ret = true
        --                     fn()
        --                     close_widget()
        --                 end
        --                 return ret
        --             end

        --             if not unlocked then
        --                 local lock_img = temp_button.image:AddChild(Image("images/widgets/sword_fairy_book_encyclopedia_ui.xml","lock.tex"))
        --                 lock_img:SetPosition(0,-2)
        --             end

        --             return temp_button
        --         end
        --     --------------------------------------------------------------------------------------------
        --     ----
        --         -- local test_button = root:AddChild(ImageButton(
        --         --     "images/widgets/sword_fairy_book_encyclopedia_ui.xml",
        --         --     "axe.tex",
        --         --     "axe.tex",
        --         --     "axe.tex",
        --         --     "axe.tex",
        --         --     "axe.tex"
        --         -- ))
        --         -- test_button:SetScale(scale,scale,scale)
        --         -- test_button:SetPosition(0,0)
        --         -- test_button.__old_t_temp_OnMouseButton = test_button.OnMouseButton
        --         -- test_button.OnMouseButton = function(self,button,down,x,y)
        --         --     local ret = self:__old_t_temp_OnMouseButton(button,down,x,y)
        --         --     if button == MOUSEBUTTON_LEFT and down == false then
        --         --         ret = true
        --         --         print("click+++")
        --         --         close_widget()
        --         --     end
        --         --     return ret
        --         -- end
        --     --------------------------------------------------------------------------------------------
        --     ---- 围绕原点 一圈布局 所有按钮
        --         -- CreateButton("axe",0,0,false,function()
        --         -- end)
        --         local buttons_cmd_table = {}
        --         local buttons_name = {
        --             "axe","cookpot","fertilize","hammer","hoe","living_log","map_blink","pickaxe","shovel","watering_can"
        --         }
        --         local raduis = 110
        --         local ange_offset = 18
        --         for i,image in ipairs(buttons_name) do
        --             local angle = ange_offset + i * 360 / #buttons_name
        --             local x = math.cos(angle * math.pi / 180) * raduis
        --             local y = math.sin(angle * math.pi / 180) * raduis
        --             CreateButton(image,x,y,true,function()
        --                 if ThePlayer:HasTag("playerghost") then 
        --                     return
        --                 end
        --                 ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("type_switch",image,book)
        --                 ThePlayer.components.playercontroller:StartAOETargetingUsing(book)
        --             end)
        --         end
        --     --------------------------------------------------------------------------------------------
        --     -----
        --         local scale_base = 0.2
        --         local scale_delta = 0.09
        --         root:SetScale(scale_base,scale_base,scale_base)
        --         local scale_task = nil
        --         scale_task = root.inst:DoPeriodicTask(FRAMES,function()
        --             scale_base = scale_base + scale_delta
        --             if scale_base > 1 then
        --                 scale_task:Cancel()
        --                 return
        --             end
        --             root:SetScale(scale_base,scale_base,scale_base)
        --         end)
        --     --------------------------------------------------------------------------------------------
        -- end

    ----------------------------------------------------------------------------------------------------------------
    ----
        -- ThePlayer.test_fn = function(reticule_fx)
        --     reticule_fx.Transform:SetScale(1,1)
        -- end
        -- local book = TheSim:FindFirstEntityWithTag("sword_fairy_book_encyclopedia")
        -- book.components.aoetargeting.reticule.reticuleprefab = "reticuleaoesummonping"
        -- book.components.aoetargeting.reticule.pingprefab = "reticuleaoesummonping"


        
            -- ThePlayer.components.sword_fairy_com_fast_cooker:DoDelta(3)

            -- print(ThePlayer.components.sword_fairy_com_magic_point_sys:GetCurrent())

        -- local inst = TheSim:FindFirstEntityWithTag("sword_fairy_book_encyclopedia")
        -- ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("type_switch","map_blink",inst) --- 通过RPC管道回传数据
        -- ThePlayer.components.playercontroller:DoAction(BufferedAction(ThePlayer, nil, ACTIONS.CAST_SPELLBOOK,inst))

        -- print(ThePlayer.replica.sword_fairy_com_map_jumper:GetCurrent())
        -- ThePlayer.components.sword_fairy_com_magic_point_sys:DoDelta(10)
        -- print(ThePlayer.replica.sword_fairy_com_magic_point_sys:GetMax())

        -- ThePlayer.test_fn = function()
        --     local temp_data = ThePlayer.replica.sword_fairy_com_magic_point_sys._net_data:value()
        --     for k, v in pairs(temp_data) do
        --         print(k,v)
        --     end
        -- end
        -- local data = {
        --     [1] = 123,
        --     [2] = 444,
        -- }
        -- ThePlayer.replica.sword_fairy_com_magic_point_sys._net_data:set(data)

        -- print(ThePlayer.replica.sword_fairy_com_drunkenness:GetMax())
        -- ThePlayer.components.sword_fairy_com_drunkenness:DoDelta(0)
        -- ThePlayer.components.sword_fairy_com_magic_point_sys:DoDelta(0)
        -- ThePlayer.components.sword_fairy_com_drunkenness:DoDeltaMax(1)
        -- ThePlayer.components.sword_fairy_com_magic_point_sys:DoDeltaMax(1)
    ----------------------------------------------------------------------------------------------------------------
    -- 地皮地块扫描测试
        -- local tile_x,tile_y,tile_z = TheWorld.Map:GetTileCenterPoint(pt.x,0,pt.z)
        -- local tile_map_x,tile_map_y = TheWorld.Map:GetTileXYAtPoint(tile_x,0,tile_z)
        -- local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(x, 0, z)
        -- TheWorld.Map:GetTileAtPoint(x, 0, z) == WORLD_TILES.FARMING_SOIL

        -- local cx,cy,cz = TheWorld.Map:GetTileCenterPoint(x,y,z)
        -- ThePlayer.Transform:SetPosition(cx,cy,cz)
        -- local line_dis = 4

        -- SpawnPrefab("log").Transform:SetPosition(cx + line_dis/2,0,cz + line_dis/2)
        -- SpawnPrefab("log").Transform:SetPosition(cx - line_dis/2,0,cz + line_dis/2)
        -- SpawnPrefab("log").Transform:SetPosition(cx + line_dis/2,0,cz - line_dis/2)
        -- SpawnPrefab("log").Transform:SetPosition(cx - line_dis/2,0,cz - line_dis/2)

        local RANGE = 15
        local RANGE_SQUARED = RANGE*RANGE

        


        ThePlayer._tile_test_fn = function(pt)
            
            -----------------------------------------------------------------------
            --- 初始化 flag 表
                local map_width,map_height = TheWorld.Map:GetSize()
                local function init_tile_flags()
                    local tile_flags = {}
                    for x=1,map_width,1 do
                        for y=1,map_height,1 do
                            tile_flags[x] = tile_flags[x] or {}
                            tile_flags[x][y] = false
                        end
                    end
                    return tile_flags
                end
                
            -----------------------------------------------------------------------
            --- 输入地块的 XY 得到这个地块中心的 世界坐标Vector3()
                local function GetWorldPointByTileXY(x,y,map_width,map_height)
                    if map_width == nil or map_height == nil then
                        map_width,map_height = TheWorld.Map:GetSize()
                    end
                    local ret_x = x - map_width/2
                    local ret_z = y - map_height/2
                    return Vector3(ret_x*TILE_SCALE,0,ret_z*TILE_SCALE)
                end
            -----------------------------------------------------------------------
            --- 获取环绕坐标
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
            -----------------------------------------------------------------------
                local tile_flags = init_tile_flags()


                local temp_points = nil
            -----------------------------------------------------------------------
            --- 圈圈范围覆盖内的地块。用脚踩扫描。
                local test_range = RANGE
                while test_range > 2 do
                    temp_points = GetSurroundPoints({
                        target = pt,
                        range = test_range,
                        num = 30
                    })
                    for i,temp_pt in pairs(temp_points) do
                        local tile_x,tile_y =  TheWorld.Map:GetTileXYAtPoint(temp_pt.x,0,temp_pt.z)
                        tile_flags[tile_x][tile_y] = Vector3(TheWorld.Map:GetTileCenterPoint(temp_pt.x,0,temp_pt.z))
                    end
                    test_range = test_range - 2
                end
            -----------------------------------------------------------------------
            --- 扫描flag表 并在合适位置生成特效
                for x = 1, map_width, 1 do
                    for y = 1, map_height, 1 do
                        if tile_flags[x][y] then
                            -------------------------------------------------------------------------
                            --- 参数表
                                local tile_mid_pt = tile_flags[x][y]
                                local is_farm_tile = TheWorld.Map:GetTileAtPoint(tile_mid_pt.x,0,tile_mid_pt.z) == WORLD_TILES.FARMING_SOIL
                            -------------------------------------------------------------------------
                                SpawnPrefab("sword_fairy_sfx_tile_outline"):PushEvent("Set",{
                                    pt = tile_flags[x][y],
                                    color = is_farm_tile and Vector3(0,255,0) or Vector3(100,100,100),
                                    a = is_farm_tile and 1 or 0.2,
                                    MultColour_Flag = true,
                                    fn = function(fx)
                                        fx:DoTaskInTime(5,fx.Remove)
                                        if is_farm_tile then
                                            -------------------------------------------------------------------------
                                            --- 添加水分
                                                TheWorld.components.farming_manager:AddSoilMoistureAtPoint(tile_mid_pt.x, 0, tile_mid_pt.z, 30)
                                            -------------------------------------------------------------------------
                                            --- 给地块施肥（3种）
                                                TheWorld.components.farming_manager:AddTileNutrients(x, y,100,100,100)
                                            -------------------------------------------------------------------------
                                            ---- 清除垃圾
                                                local need_2_remove_prefabs = {
                                                    ["farm_soil"] = true,   --- 没放种子的土坑
                                                    ["farm_soil_debris"] = true,  --- 垃圾物品
                                                }
                                                local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(tile_mid_pt.x, 0,tile_mid_pt.z)
                                                for k, tempInst in pairs(ents) do
                                                    -- print(k,tempInst)
                                                    if need_2_remove_prefabs[tempInst.prefab] then
                                                        tempInst:Remove()
                                                    end
                                                end
                                            -------------------------------------------------------------------------
                                            ---- 开始挖坑
                                                local soil_delta = 4/3
                                                local soil_delta_sq = soil_delta*soil_delta
                                                local function CanPlantAtPoint(x,y,z)
                                                    if not TheWorld.Map:IsFarmableSoilAtPoint(x, 0,z) then
                                                        return false
                                                    end
                                                    local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(x, 0,z)
                                                    for k, temp_inst in pairs(ents) do
                                                        if temp_inst:HasOneOfTags({"plant","farm_plant"}) and temp_inst:GetDistanceSqToPoint(x, 0,z) < soil_delta_sq then
                                                            return false
                                                        end
                                                    end
                                                    return true
                                                end
                                                local pt_offsets = {
                                                    Vector3(-soil_delta,0,-soil_delta) , Vector3(0,0,-soil_delta) , Vector3(soil_delta,0,-soil_delta) ,
                                                    Vector3(-soil_delta,0,   0  ) , Vector3(0,0,0) , Vector3(soil_delta,0,0) ,
                                                    Vector3(-soil_delta,0,soil_delta) , Vector3(0,0,soil_delta) , Vector3(soil_delta,0,soil_delta) ,
                                                }
                                                for k, temp_offset in pairs(pt_offsets) do
                                                    local temp_x = tile_mid_pt.x + temp_offset.x
                                                    local temp_y = tile_mid_pt.y + temp_offset.y
                                                    local temp_z = tile_mid_pt.z + temp_offset.z
                                                    if CanPlantAtPoint(temp_x, 0,temp_z) then
                                                        SpawnPrefab("farm_soil").Transform:SetPosition(temp_x,0,temp_z)
                                                    end
                                                end
                                            -------------------------------------------------------------------------
                                        end
                                    end
                                })
                            -------------------------------------------------------------------------
                        end
                    end
                end
            -----------------------------------------------------------------------
        end
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))