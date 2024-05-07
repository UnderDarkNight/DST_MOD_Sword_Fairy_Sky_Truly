--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    无字天书

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets = {
    Asset("ANIM", "anim/sword_fairy_book_empty.zip"),
    Asset("ANIM", "anim/sword_fairy_book_empty.zip"),
    Asset( "IMAGE", "images/inventoryimages/sword_fairy_book_empty.tex" ),
    Asset( "ATLAS", "images/inventoryimages/sword_fairy_book_empty.xml" ),
}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 
    local function GetStringsTable(prefab_name)
        local temp_name = "sword_fairy_book_empty"
        return TUNING["sword_fairy_sky_truly.fn"].GetStringsTable(temp_name or prefab_name)
    end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function read_event_setup(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:ListenForEvent("type_switch_without_aoe",function()
            local owner = inst.components.inventoryitem:GetGrandOwner()
            if owner and owner:HasTag("player") and owner.components.playercontroller then
                owner.components.playercontroller:DoAction(BufferedAction(owner, nil, ACTIONS.CAST_SPELLBOOK,inst))
            end
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 右键交互组件.需要完完全全覆盖官方的右键交互组件
    local function right_click_ation_com_setup(inst)
        inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_workable",function(inst,replica_com)
            replica_com:SetText("sword_fairy_book_empty",STRINGS.ACTIONS.OPEN_CRAFTING.READ)
            replica_com:SetTestFn(function(inst,doer)
                return doer:HasTag("sword_fairy_sky_truly") and inst.replica.inventoryitem:IsGrandOwner(doer)                
            end)
            replica_com:SetSGAction(nil)
            replica_com:SetPreActionFn(function(inst,doer)
                -- 只有指定玩家才能打开UI
                if doer:HasTag("sword_fairy_sky_truly") and ThePlayer and ThePlayer == doer then
                    -- inst:PushEvent("button_ui_open",doer)
                    ThePlayer.replica.sword_fairy_com_rpc_event:PushEvent("type_switch_without_aoe",{},inst) --- 通过RPC管道回传数据
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

------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("sword_fairy_book_empty")
	inst.AnimState:SetBuild("sword_fairy_book_empty")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("book")
	inst:AddTag("sword_fairy_book_empty")

	MakeInventoryFloatable(inst, "med", nil, 0.75)
	inst.entity:SetPristine()

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 数据记录器
        if TheWorld.ismastersim then
            inst:AddComponent("sword_fairy_com_data")
        end
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        read_event_setup(inst)
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
    ------------------------------------------------------------------------------------------------------------------------------------------------------
    --[[
        ThePlayer.components.playercontroller:DoAction(BufferedAction(ThePlayer, nil, ACTIONS.CAST_SPELLBOOK,inst))  --- 只能在服务端执行？？
        只能走下面这条函数。client 直接调用 启用那种不需要 放 aoe 圈圈的法术
    ]]--
        inst.components.spellbook:SetSpellFn(function(inst,doer)
            -- print("fake error spellbook com ",inst,doer)
            ----------------------------------------------------------------------
            --- CD,一天只能成功读一次
                local can_cast_spell = true
                local last_spell_used_day = doer.components.sword_fairy_com_data:Add("sword_fairy_book_empty_day",0)
                if last_spell_used_day == TheWorld.state.cycles then
                    can_cast_spell = false
                end
                if not can_cast_spell then
                    doer:DoTaskInTime(0,function()
                        doer.components.talker:Say(GetStringsTable()["next_day"])
                    end)
                    return false
                end
            ----------------------------------------------------------------------
            --- 参数表
                local percent_rate = 0.9
                local hunger_cost = doer.components.hunger.max * percent_rate
                local sanity_cost = doer.components.sanity.max * percent_rate
                local health_cost = doer.components.health.maxhealth * percent_rate
            ----------------------------------------------------------------------
            --- 消耗
                if doer.components.hunger.current < hunger_cost then
                    doer:DoTaskInTime(0,function()
                        doer.components.talker:Say(GetStringsTable()["spell_fail"])
                    end)
                    return false
                end
                if doer.components.sanity.current < sanity_cost then
                    doer:DoTaskInTime(0,function()
                        doer.components.talker:Say(GetStringsTable()["spell_fail"])
                    end)
                    return false
                end
                if doer.components.health.currenthealth < health_cost then
                    doer:DoTaskInTime(0,function()
                        doer.components.talker:Say(GetStringsTable()["spell_fail"])
                    end)
                    return false
                end
            ----------------------------------------------------------------------
            --- 执行消耗
                doer.components.hunger:DoDelta(-hunger_cost)
                doer.components.sanity:DoDelta(-sanity_cost)
                doer.components.health:DoDelta(-health_cost)
            ----------------------------------------------------------------------
            --- 消耗完毕
                local ret = inst.components.sword_fairy_com_data:Add("read",1)
                if ret >= 7 then
                    inst:Remove()
                    doer.components.inventory:GiveItem(SpawnPrefab("sword_fairy_book_encyclopedia"))
                    return true
                end
            ----------------------------------------------------------------------
            ----
                doer.components.talker:Say(GetStringsTable()["spell_succeed"])
                doer.components.sword_fairy_com_data:Set("sword_fairy_book_empty_day",TheWorld.state.cycles)
            ----------------------------------------------------------------------
            return true
        end)
    ------------------------------------------------------------------------------------------------------------------------------------------------------

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
        inst.components.aoetargeting.reticule.reticuleprefab = "sword_fairy_book_empty_spell_reticule_fx"
        inst.components.aoetargeting.reticule.pingprefab = nil
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



	if not TheWorld.ismastersim then
		return inst
	end


	-- inst.swap_build = "book_maxwell"
	inst.swap_build = "sword_fairy_book_empty"

	inst:AddComponent("inspectable")


	inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("cane")
    inst.components.inventoryitem.imagename = "sword_fairy_book_empty"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sword_fairy_book_empty.xml"

	inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(function(inst, doer, pt)        
        print("++++++++++++",inst,doer,pt)
        return true
    end)


    -- inst.components.aoetargeting:SetTargetFX("reticuleaoecctarget") --- 施法期间的fx
    inst.components.aoetargeting:SetTargetFX("sword_fairy_book_empty_spell_reticule_fx") --- 施法期间的fx

	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)


	inst.castsound = "maxwell_rework/shadow_magic/cast"
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
            else                                
                inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
	return inst
end
----------------------------------------------------------------------------------------------------------------------------------------

return Prefab("sword_fairy_book_empty", fn, assets)