
local assets = {

}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装界面UI
    local SPELL_PARAM = {
        ["axe"] = {
            ["name"] = "axe",
            ["cd"] = 7,
            ["mp_cost"] = 7,
        },
        ["cookpot"] = {
            ["name"] = "cookpot",
            ["cd"] = 1,
            ["mp_cost"] = 7,            
        },
        ["fertilize"] = {
            ["name"] = "fertilize",
            ["cd"] = 0,
            ["mp_cost"] = 7,
        },
        ["hammer"] = {
            ["name"] = "hammer",
            ["cd"] = 0,
            ["mp_cost"] = 7,
        },
        ["hoe"] = {
            ["name"] = "hoe",
            ["cd"] = 0,
            ["mp_cost"] = 7,
        },
        ["living_log"] = {
            ["name"] = "living_log",
            ["cd"] = 0,
            ["mp_cost"] = 7,
        },
        ["map_blink"] = {
            ["name"] = "map_blink",
            ["cd"] = 1,
            ["mp_cost"] = 7,
            ["not_aoe"] = true,
        },
        ["pickaxe"] = {
            ["name"] = "pickaxe",
            ["cd"] = 7,
            ["mp_cost"] = 7,
        },
        ["shovel"] = {
            ["name"] = "shovel",
            ["cd"] = 7,
            ["mp_cost"] = 7,
        },
        ["watering_can"] = {
            ["name"] = "watering_can",
            ["cd"] = 0,
            ["mp_cost"] = 14,
        },
    }

    ------------------------------------------------------------------------
    ----- 参数表格转置一下
        local spell_cd_days = {}
        local buttons_name = {}
        local spell_mp_cost = {}
        for index, cmd_table in pairs(SPELL_PARAM) do
            spell_cd_days[index] = cmd_table.cd
            spell_mp_cost[index] = cmd_table.mp_cost
            table.insert(buttons_name,index)
        end
        if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
            for index, v in pairs(spell_cd_days) do
                spell_cd_days[index] = 0
                spell_mp_cost[index] = 1
            end
        end
    ------------------------------------------------------------------------
    local function ui_event_setup(inst)
        inst:ListenForEvent("button_ui_open",function(inst,cmd_table)            
            --------------------------------------------------------------------------------------------
            ---- 
                cmd_table = cmd_table or {}
                if not (ThePlayer and cmd_table.userid == ThePlayer.userid and ThePlayer.HUD ) then
                    return
                end
                local player = ThePlayer
                -- print("++++++++++ info cd checker +++++++")
                -- for k, v in pairs(cmd_table) do
                --     print(k,v)
                -- end
                -- print("++++++++++++ info ++++++++++++++++")
            --------------------------------------------------------------------------------------------
            ---- 顺着官方逻辑  PlayerHud:OpenSpellWheel
                local function CloseAllChestContainerWidgets(self)
                    for _, v in pairs(self.controls.containers) do
                        --cheap check for "chest" type containers
                        if v:GetParent() == self.controls.containerroot then
                            v:Close()
                        end
                    end
                end
                ThePlayer.HUD:CloseCrafting()
                if ThePlayer.HUD:IsControllerInventoryOpen() then
                    ThePlayer.HUD:CloseControllerInventory()
                end
                CloseAllChestContainerWidgets(ThePlayer.HUD)
            --------------------------------------------------------------------------------------------
            ----
                if inst.front_hud_root ~= nil then
                    inst.front_hud_root:Kill()
                    inst.front_hud_root = nil
                    return
                end
            --------------------------------------------------------------------------------------------
            ----
                inst.front_hud_root = ThePlayer.HUD:AddChild(Screen())
                local front_hud_root = inst.front_hud_root

                local function close_widget()
                    TheFrontEnd:PopScreen(front_hud_root) -- 归还角色操作权
                    inst.front_hud_root:Kill()
                    inst.front_hud_root = nil
                end
            --------------------------------------------------------------------------------------------
            -------- 设置锚点
                front_hud_root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                front_hud_root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                front_hud_root:SetPosition(0,0)
                front_hud_root:MoveToBack()
                front_hud_root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            --------------------------------------------------------------------------------------------
            ----
                local root = front_hud_root:AddChild(Widget())
            --------------------------------------------------------------------------------------------
            ----
                local scale = 0.6
            --------------------------------------------------------------------------------------------
            ---- 按钮创建统一API
                local function CreateButton(image,x,y,unlocked,fn)
                    local ret_image = image..".tex"
                    if cmd_table[image] == false then   ---- 如果CD冷却中
                        ret_image = image.."_gray.tex"
                    end
                    local temp_button = root:AddChild(ImageButton(
                        "images/widgets/sword_fairy_book_encyclopedia_ui.xml",
                        ret_image,ret_image,ret_image,ret_image,ret_image
                    ))
                    temp_button:SetScale(scale,scale,scale)
                    temp_button:SetPosition(x or 0,y or 0)
                    if not unlocked or cmd_table[image] == false then
                        fn = function() 
                            print("info : can not cast this spell",image,unlocked)
                        end
                    end
                    temp_button.__old_t_temp_OnMouseButton = temp_button.OnMouseButton
                    temp_button.OnMouseButton = function(self,button,down,x,y)
                        local ret = self:__old_t_temp_OnMouseButton(button,down,x,y)
                        if button == MOUSEBUTTON_LEFT and down == false then
                            ret = true
                            fn()
                            close_widget()
                        end
                        return ret
                    end

                    if not unlocked then
                        local lock_img = temp_button.image:AddChild(Image("images/widgets/sword_fairy_book_encyclopedia_ui.xml","lock.tex"))
                        lock_img:SetPosition(0,-2)
                    end

                    return temp_button
                end
            --------------------------------------------------------------------------------------------
            ----
            --------------------------------------------------------------------------------------------
            ---- 围绕原点 一圈布局 所有按钮
                -- CreateButton("axe",0,0,false,function()
                -- end)
                local buttons_cmd_table = {}

                local raduis = 110
                local ange_offset = 18
                for i,image in ipairs(buttons_name) do
                    local angle = ange_offset + i * 360 / #buttons_name
                    local x = math.cos(angle * math.pi / 180) * raduis
                    local y = math.sin(angle * math.pi / 180) * raduis
                    CreateButton(image,x,y,inst:HasTag("unlocked_"..image),function()
                        if ThePlayer:HasTag("playerghost") then 
                            return
                        end
                        if SPELL_PARAM[image].not_aoe == true then
                            ---- 非AOE 状态直接请求执行动作
                            -- ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("type_switch",image,inst) --- 通过RPC管道回传数据
                            -- ThePlayer.components.playercontroller:DoAction(BufferedAction(ThePlayer, nil, ACTIONS.CAST_SPELLBOOK,inst))

                            ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("type_switch_without_aoe",image,inst) --- 通过RPC管道回传数据
                        else
                            ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("type_switch",image,inst) --- 通过RPC管道回传数据
                            ThePlayer.components.playercontroller:StartAOETargetingUsing(inst)
                        end

                    end)
                end
            --------------------------------------------------------------------------------------------
            -----
                local scale_base = 0.2
                local scale_delta = 0.09
                root:SetScale(scale_base,scale_base,scale_base)
                local scale_task = nil
                scale_task = root.inst:DoPeriodicTask(FRAMES,function()
                    scale_base = scale_base + scale_delta
                    if scale_base > 1 then
                        scale_task:Cancel()
                        return
                    end
                    root:SetScale(scale_base,scale_base,scale_base)
                end)
            --------------------------------------------------------------------------------------------
            ----- 锁住角色移动操作
                ThePlayer.HUD:OpenScreenUnderPause(front_hud_root)
                front_hud_root.__old_test_temp_OnControl = root.OnControl
                front_hud_root.OnControl = function(self,control, down)
                    -- print("widget key down",control,down)
                    if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                        close_widget()
                    end
                    return self:__old_test_temp_OnControl(control,down)
                end                
            --------------------------------------------------------------------------------------------
            ----- 右键取消圆环
                local old_OnMouseButton = front_hud_root.OnMouseButton
                front_hud_root.OnMouseButton = function(self,button, down, x, y)
                    if button == MOUSEBUTTON_RIGHT and down then
                        close_widget()
                    end
                    return old_OnMouseButton(self,button, down, x, y)
                end
            --------------------------------------------------------------------------------------------
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CD and MP Checker
    local function cd_and_mp_checker_setup(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:ListenForEvent("book_right_clicked",function(inst)
            local owner = inst.components.inventoryitem:GetGrandOwner()
            print("info client side right clicked :",owner)
            if not ( owner and owner:HasTag("player") ) then
                return
            end
            local cmd_table = {
                userid = owner.userid,
            }
            -----------------------------------------------------
            --- CD 检查器
                local cd_data = inst.components.sword_fairy_com_data:Get("cd") or {}
                for index, current_cd in pairs(spell_cd_days) do
                    if cd_data[index] == nil then
                        cmd_table[index] = true
                    else
                        if TheWorld.state.cycles - cd_data[index] >= current_cd then
                            cmd_table[index] = true
                        else
                            cmd_table[index] = false
                        end
                    end
                end
            -----------------------------------------------------
            --- MP 检查器
                local current_mp = owner.replica.sword_fairy_com_magic_point_sys:GetCurrent()
                for index, need_mp in pairs(spell_mp_cost) do
                    if cmd_table[index] == true and current_mp < need_mp and inst:HasTag("unlocked_"..index) then
                        cmd_table[index] = false
                    end
                end
            -----------------------------------------------------
            owner.components.sword_fairy_com_rpc_event:PushEvent("button_ui_open",cmd_table,inst) -- 下发打开UI的event 和数据
        end)
        inst:ListenForEvent("spell_casted",function(inst,spell_type)
            local cd_data = inst.components.sword_fairy_com_data:Get("cd") or {}
            cd_data[spell_type] = TheWorld.state.cycles
            inst.components.sword_fairy_com_data:Set("cd",cd_data)
        end)

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 右键交互组件.需要完完全全覆盖官方的右键交互组件
    local function right_click_ation_com_setup(inst)
        inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_workable",function(inst,replica_com)
            replica_com:SetText("sword_fairy_book_encyclopedia",STRINGS.ACTIONS.OPEN_CRAFTING.READ)
            replica_com:SetTestFn(function(inst,doer)
                return doer:HasTag("sword_fairy_sky_truly") and inst.replica.inventoryitem:IsGrandOwner(doer)                
            end)
            replica_com:SetSGAction(nil)
            replica_com:SetPreActionFn(function(inst,doer)
                -- 只有指定玩家才能打开UI
                if doer:HasTag("sword_fairy_sky_truly") then
                    -- inst:PushEvent("button_ui_open",doer)
                    doer.replica.sword_fairy_com_rpc_event:PushEvent("book_right_clicked",{},inst)
                end
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("sword_fairy_com_workable")
            inst.components.sword_fairy_com_workable:SetCanWorlk(true)
            inst.components.sword_fairy_com_workable:SetActiveFn(function(inst,doer)
                return true
            end)
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 类别切换
    local function book_type_event_setup(inst)
        inst:ListenForEvent("type_switch",function(inst,book_type)
            inst.book_type = book_type
            print("info : switch book type to "..book_type)
        end)
        inst:ListenForEvent("type_switch_without_aoe",function(inst,book_type)
            inst.book_type = book_type
            local owner = inst.components.inventoryitem:GetGrandOwner()
            if owner and owner:HasTag("player") and owner.components.playercontroller then
                owner.components.playercontroller:DoAction(BufferedAction(owner, nil, ACTIONS.CAST_SPELLBOOK,inst))
            end
        end)
        -- "axe","cookpot","fertilize","hammer","hoe","living_log","map_blink","pickaxe","shovel","watering_can"
        local book_spell_by_type = require("prefabs/02_items/03_spell_book_spells")(SPELL_PARAM)
        inst.components.aoespell:SetSpellFn(function(inst, doer, pt)
            local book_type = tostring(inst.book_type)
            if book_spell_by_type[book_type] then
                book_spell_by_type[book_type](inst, doer, pt)
                inst:PushEvent("spell_casted",book_type)
            end
            return true
        end)
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        --[[
            ThePlayer.components.playercontroller:DoAction(BufferedAction(ThePlayer, nil, ACTIONS.CAST_SPELLBOOK,inst))  --- 只能在服务端执行？？
            只能走下面这条函数。client 直接调用 启用那种不需要 放 aoe 圈圈的法术
        ]]--
            inst.components.spellbook:SetSpellFn(function(inst,doer)
                print("spellbook com ",inst,doer)
                local pt = Vector3(doer.Transform:GetWorldPosition())
                local book_type = tostring(inst.book_type)
                if book_spell_by_type[book_type] then
                    book_spell_by_type[book_type](inst, doer, pt)
                end
                return true
            end)
        ------------------------------------------------------------------------------------------------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 物品解锁
    local function type_unlocker_setup(inst)
        local acceptitem = {
            ["goldenaxe"] = { -- 斧头
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_axe")
                end,
                ["ACCEPTED"] = function(inst,item,doer)                    
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_axe",true)
                    inst:AddTag("unlocked_axe")
                    return true
                end,
            },
            ["goldenpickaxe"] = { --- 镐子
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_pickaxe")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_pickaxe",true)
                    inst:AddTag("unlocked_pickaxe")
                    return true
                end,
            },
            ["goldenshovel"] = {  ---- 铲子
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_shovel")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_shovel",true)
                    inst:AddTag("unlocked_shovel")
                    return true
                end,
            },
            ["hammer"] = {  ---- 锤子
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_hammer")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_hammer",true)
                    inst:AddTag("unlocked_hammer")
                    return true
                end,
            },
            ["golden_farm_hoe"] = {  ---- 锄头
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_hoe")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_hoe",true)
                    inst:AddTag("unlocked_hoe")
                    return true
                end,
            },
            ["poop"] = {  ---- 便便
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_fertilize")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_fertilize",true)
                    inst:AddTag("unlocked_fertilize")
                    return true
                end,
            },
            ["compost"] = {  ---- 肥堆
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_fertilize")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_fertilize",true)
                    inst:AddTag("unlocked_fertilize")
                    return true
                end,
            },
            ["soil_amender"] = {  ---- 催长剂
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_fertilize")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_fertilize",true)
                    inst:AddTag("unlocked_fertilize")
                    return true
                end,
            },
            ["soil_amender_fermented"] = {  ---- 催长剂
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_fertilize")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_fertilize",true)
                    inst:AddTag("unlocked_fertilize")
                    return true
                end,
            },
            ["livinglog"] = {  ---- 活木
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_living_log")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_living_log",true)
                    inst:AddTag("unlocked_living_log")
                    return true
                end,
            },
            ["wateringcan"] = {  ---- 水壶
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_watering_can")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.finiteuses:GetPercent() < 1 then
                        return false
                    end
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_watering_can",true)
                    inst:AddTag("unlocked_watering_can")
                    return true
                end,
            },
            ["charcoal"] = {  ---- 木炭
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_cookpot")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_cookpot",true)
                    inst:AddTag("unlocked_cookpot")
                    return true
                end,
            },
            ["goldnugget"] = {  ---- 金子
                ["TEST"] = function(inst,item,doer)
                    return not inst:HasTag("unlocked_map_blink")
                end,
                ["ACCEPTED"] = function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst.components.sword_fairy_com_data:Set("unlocked_map_blink",true)
                    inst:AddTag("unlocked_map_blink")
                    return true
                end,
            },
        }
        inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_acceptable",function(inst,replica_com)
            replica_com:SetText("sword_fairy_book_encyclopedia",STRINGS.ACTIONS.GIVE.READY)
            replica_com:SetTestFn(function(inst,item,doer)
                local item_prefab = item.prefab
                if acceptitem[item_prefab] then
                    return acceptitem[item_prefab]["TEST"](inst,item,doer)
                end
                return false
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("sword_fairy_com_acceptable")
            inst.components.sword_fairy_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                local item_prefab = item.prefab
                if acceptitem[item_prefab] then
                    return acceptitem[item_prefab]["ACCEPTED"](inst,item,doer)                     
                end
                return false
            end)
            inst.components.sword_fairy_com_data:AddOnLoadFn(function() --- 加载的时候检查已解锁的
                for k, image in pairs(buttons_name) do
                    local temp_index = "unlocked_"..image
                    if inst.components.sword_fairy_com_data:Get(temp_index) then
                        inst:AddTag(temp_index)
                    end
                end
            end)
        end

    end    
------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("book_maxwell")
	inst.AnimState:SetBuild("book_maxwell")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("book")
	inst:AddTag("sword_fairy_book_encyclopedia")

	MakeInventoryFloatable(inst, "med", nil, 0.75)
	inst.entity:SetPristine()

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 数据记录器
        if TheWorld.ismastersim then
            inst:AddComponent("sword_fairy_com_data")
        end
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- type unlocker 类别解锁
        type_unlocker_setup(inst)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- CD 检查器
        cd_and_mp_checker_setup(inst)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 安装界面UI
        ui_event_setup(inst)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 右键交互组件
        right_click_ation_com_setup(inst)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- playercontroller 里必须走动的组件
        inst:AddComponent("spellbook")
        inst.components.spellbook:SetItems({
            [1] = {
                onselect = function(inst)
                end,
            },
        })
        inst.components.spellbook.GetSelectedSpell = function(self) --- hook 官方API 保证执行流畅
            return 1
        end
        inst.components.spellbook:SetRequiredTag("sword_fairy_sky_truly")
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ----- 虚线圈圈指示器  直接激活函数 ThePlayer.components.playercontroller:StartAOETargetingUsing(book)
        inst:AddComponent("aoetargeting")
        inst.components.aoetargeting:SetAllowWater(true)
        inst.components.aoetargeting.reticule.targetfn = function(...) --- 好像没啥用，没检测到执行
                                                            local player = ThePlayer
                                                            local ground = TheWorld.Map
                                                            local pos = Vector3()
                                                            --Cast range is 8, leave room for error
                                                            --4 is the aoe range
                                                            for r = 7, 0, -.25 do
                                                                pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
                                                                if ground:IsPassableAtPoint(pos.x, 0, pos.z, true) and not ground:IsGroundTargetBlocked(pos) then
                                                                    return pos
                                                                end
                                                            end
                                                            return pos
                                                        end
        inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
        inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
        inst.components.aoetargeting.reticule.ease = true
        inst.components.aoetargeting.reticule.mouseenabled = true
        inst.components.aoetargeting.reticule.twinstickmode = 1
        inst.components.aoetargeting.reticule.twinstickrange = 8
        inst.components.aoetargeting.reticule.updatepositionfn = function(inst,pt,reticule_fx,...) --- 覆盖替换官方的 坐标更新函数
            reticule_fx.Transform:SetPosition(pt.x, pt.y, pt.z)
            reticule_fx.Ready = true
        end
        inst.components.aoetargeting:SetDeployRadius(0)
        inst.components.aoetargeting:SetShouldRepeatCastFn(nil)
        -- inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoe"
        -- inst.components.aoetargeting.reticule.pingprefab = "reticuleaoeping"
        inst.components.aoetargeting.reticule.reticuleprefab = "sword_fairy_book_encyclopedia_spell_reticule_fx"
        inst.components.aoetargeting.reticule.pingprefab = nil
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---  aoetargeting.StartTargeting 相关的hook，为了添加 update 函数    【笔记】这段仅仅是测试使用。
        -- local old_aoetargeting_StartTargeting = inst.components.aoetargeting.StartTargeting
        -- inst.components.aoetargeting.StartTargeting = function(self,...)
        --     print("fake error ++66")
        --     -- local reticule = self.inst.components.reticule
        --     -- if reticule then
        --         if ThePlayer.test_fn then
        --             ThePlayer.test_fn(inst)
        --         end
        --     -- end
        --     local old_ret = {old_aoetargeting_StartTargeting(self,...)}

        --     return unpack(old_ret)
        -- end    
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



	if not TheWorld.ismastersim then
		return inst
	end


	inst.swap_build = "book_maxwell"

	inst:AddComponent("inspectable")


	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("cane")

	inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(function(inst, doer, pt)        
        print("++++++++++++",inst,doer,pt)
        return true
    end)

    book_type_event_setup(inst)

    -- inst.components.aoetargeting:SetTargetFX("reticuleaoecctarget") --- 施法期间的fx
    inst.components.aoetargeting:SetTargetFX("sword_fairy_book_encyclopedia_spell_reticule_fx") --- 施法期间的fx

	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)


	inst.castsound = "maxwell_rework/shadow_magic/cast"

	return inst
end
----------------------------------------------------------------------------------------------------------------------------------------
--- 圈圈指示特效
    local PLACER_SCALE = 1.55
    local reticule_fx = function()
        local inst = CreateEntity()
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        inst:AddTag("placer")
        --[[Non-networked entity]]
        inst.entity:SetCanSleep(false)
        inst.persists = false

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst.AnimState:SetBank("firefighter_placement")
        inst.AnimState:SetBuild("firefighter_placement")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(1)
        inst.AnimState:SetAddColour(0, .2, .5, 0)
        inst.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)

        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------

return Prefab("sword_fairy_book_encyclopedia", fn, assets),
    Prefab("sword_fairy_book_encyclopedia_spell_reticule_fx", reticule_fx)