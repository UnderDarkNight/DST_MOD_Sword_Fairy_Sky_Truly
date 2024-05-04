
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
    local buttons_name = {
        "axe","cookpot","fertilize","hammer","hoe","living_log","map_blink","pickaxe","shovel","watering_can"
    }
    local function ui_event_setup(inst)
        inst:ListenForEvent("button_ui_open",function(inst,player)            
            --------------------------------------------------------------------------------------------
            ---- 
                if player.HUD == nil then
                    return
                end
                if player ~= ThePlayer then
                    return
                end
            --------------------------------------------------------------------------------------------
            ----
                if inst.front_hud_root ~= nil then
                    inst.front_hud_root:Kill()
                    inst.front_hud_root = nil
                    return
                end
            --------------------------------------------------------------------------------------------
            ----
                inst.front_hud_root = ThePlayer.HUD:AddChild(Widget())
                local front_root = inst.front_hud_root

                local function close_widget()
                    inst.front_hud_root:Kill()
                    inst.front_hud_root = nil
                end
            --------------------------------------------------------------------------------------------
            -------- 设置锚点
                front_root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                front_root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                front_root:SetPosition(0,0)
                front_root:MoveToBack()
                front_root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            --------------------------------------------------------------------------------------------
            ----
                local root = front_root:AddChild(Widget())
            --------------------------------------------------------------------------------------------
            ----
                local scale = 0.6
            --------------------------------------------------------------------------------------------
            ---- 按钮创建统一API
                local function CreateButton(image,x,y,unlocked,fn)
                    local ret_image = image..".tex"
                    local temp_button = root:AddChild(ImageButton(
                        "images/widgets/sword_fairy_book_encyclopedia_ui.xml",
                        ret_image,ret_image,ret_image,ret_image,ret_image
                    ))
                    temp_button:SetScale(scale,scale,scale)
                    temp_button:SetPosition(x or 0,y or 0)
                    if not unlocked then
                        fn = function() end
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
                        ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("type_switch",image,inst) --- 通过RPC管道回传数据
                        ThePlayer.components.playercontroller:StartAOETargetingUsing(inst)
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
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 右键交互组件.需要完完全全覆盖官方的右键交互组件
    local function right_click_ation_com_setup(inst)
        inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_workable",function(inst,replica_com)
            replica_com:SetText("sword_fairy_book_encyclopedia",STRINGS.ACTIONS.OPEN_CRAFTING.READ)
            replica_com:SetTestFn(function(inst,doer)
                -- if doer:HasTag("sword_fairy_sky_truly") then
                --     replica_com:SetSGAction(nil)
                -- else
                --     replica_com:SetSGAction("give")
                -- end
                return doer:HasTag("sword_fairy_sky_truly") and inst.replica.inventoryitem:IsGrandOwner(doer)                
            end)
            replica_com:SetSGAction(nil)
            replica_com:SetPreActionFn(function(inst,doer)
                -- 只有指定玩家才能打开UI
                if doer:HasTag("sword_fairy_sky_truly") then
                    inst:PushEvent("button_ui_open",doer)
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
        -- "axe","cookpot","fertilize","hammer","hoe","living_log","map_blink","pickaxe","shovel","watering_can"
        local book_spell_by_type = {
            ["axe"] = function(inst,doer,pt)
                print("axe  work : ",doer,pt)
            end,
            ["cookpot"] = function(inst,doer,pt)
                print("cookpot  work : ",doer,pt)
            end,
           ["fertilize"] = function(inst,doer,pt)
                print("fertilize  work : ",doer,pt)
           end,
           ["hammer"] = function(inst,doer,pt)
                print("hammer  work : ",doer,pt)
           end,
           ["hoe"] = function(inst,doer,pt)
                print("hoe  work : ",doer,pt)
           end,
           ["living_log"] = function(inst,doer,pt)
                print("living_log  work : ",doer,pt)
           end,
           ["map_blink"] = function(inst,doer,pt)
                print("map_blink  work : ",doer,pt)
           end,
           ["pickaxe"] = function(inst,doer,pt)
                print("pickaxe  work : ",doer,pt)
           end,
           ["shovel"] = function(inst,doer,pt)
                print("shovel  work : ",doer,pt)
           end,
           ["watering_can"] = function(inst,doer,pt)
                print("watering_can  work : ",doer,pt)
           end,
        }
        inst.components.aoespell:SetSpellFn(function(inst, doer, pt)        
            if book_spell_by_type[tostring(inst.book_type)] then
                book_spell_by_type[tostring(inst.book_type)](inst, doer, pt)
            end
            return true
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
        end
        inst.components.aoetargeting:SetDeployRadius(0)
        inst.components.aoetargeting:SetShouldRepeatCastFn(nil)
        inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoe"
        inst.components.aoetargeting.reticule.pingprefab = "reticuleaoeping"
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


	inst.entity:SetPristine()

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

    inst.components.aoetargeting:SetTargetFX("reticuleaoecctarget")

	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)


	inst.castsound = "maxwell_rework/shadow_magic/cast"

	return inst
end

return Prefab("sword_fairy_book_encyclopedia", fn, assets)