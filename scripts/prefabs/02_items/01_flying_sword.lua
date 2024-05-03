------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    飞剑

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 参数
    local MP_COST = TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 3 or 7
    local NORMAL_DAMAGE = 34        --- 普通攻击伤害
    local LUNGE_DAMAGE = 34         --- 冲刺对每个目标造成的伤害
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 素材
    local assets =
    {
        Asset("ANIM", "anim/sword_fairy_weapon_flying_sword.zip"),
        Asset("ANIM", "anim/sword_fairy_weapon_flying_sword_swap.zip"),
        Asset( "IMAGE", "images/inventoryimages/sword_fairy_weapon_flying_sword.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/sword_fairy_weapon_flying_sword.xml" ),
    }


------------------------------------------------------------------------------------------------------------------------

    local function RefreshAttunedSkills(inst, owner, prevowner)
        inst.components.aoetargeting:SetEnabled(inst.components.rechargeable:IsCharged())
    end

    local function WatchSkillRefresh(inst, owner)
        if inst._owner then
            inst:RemoveEventCallback("onactivateskill_server", inst._onskillrefresh, inst._owner)
            inst:RemoveEventCallback("ondeactivateskill_server", inst._onskillrefresh, inst._owner)
        end
        inst._owner = owner
        if owner then
            inst:ListenForEvent("onactivateskill_server", inst._onskillrefresh, owner)
            inst:ListenForEvent("ondeactivateskill_server", inst._onskillrefresh, owner)
        end
    end

------------------------------------------------------------------------------------------------------------------------

local function OnEquip(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:OverrideSymbol("swap_object", "sword_fairy_weapon_flying_sword_swap", "swap_object")
    
    if not (owner:HasTag("player") and owner:HasTag("sword_fairy_sky_truly") ) then
        return
    end
    -------------------------------------------------------------------------------
    ---- 
        WatchSkillRefresh(inst, owner)
        RefreshAttunedSkills(inst, owner)
        if inst.components.aoetargeting ~= nil and
            inst.components.aoetargeting:IsEnabled() and
            inst.components.rechargeable ~= nil and
            inst.components.rechargeable:GetTimeToCharge() < inst._cooldown
        then
            inst.components.rechargeable:Discharge(inst._cooldown)
        end
    -------------------------------------------------------------------------------
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if not (owner:HasTag("player") and owner:HasTag("sword_fairy_sky_truly") ) then
        return
    end
    -------------------------------------------------------------------------------
    ----- 
        WatchSkillRefresh(inst, nil)
        RefreshAttunedSkills(inst, nil, owner)
    -------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------






------------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sword_fairy_weapon_flying_sword")
    inst.AnimState:SetBuild("sword_fairy_weapon_flying_sword")
    inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("battlespear")

    -- weapon (from weapon component) added to pristine state for optimization.
    inst:AddTag("weapon")

    -- MakeInventoryFloatable(inst, "med", 0.1, {0.7, 0.5, 0.7})
    ------------------------------------------------------------------------------------
        -- aoeweapon_lunge (from aoeweapon_lunge component) added to pristine state for optimization.
        inst:AddTag("aoeweapon_lunge")

        -- rechargeable (from rechargeable component) added to pristine state for optimization.
        inst:AddTag("rechargeable")
    
        inst:AddComponent("aoetargeting")
        inst.components.aoetargeting:SetAllowRiding(false)
        inst.components.aoetargeting.reticule.reticuleprefab = "reticuleline"           ----- 箭头指示器prefab
        inst.components.aoetargeting.reticule.pingprefab = "reticulelineping"           ----- 箭头指示器prefab 【疑惑】为什么有两个？

        inst.components.aoetargeting.reticule.targetfn = function()                     ------ 瞄准目标方向
            --Cast range is 8, leave room for error (6.5 lunge)
            return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
        end

        inst.components.aoetargeting.reticule.mousetargetfn = function(inst, mousepos)  ------ 基于鼠标控制的角度旋转
            if mousepos ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()
                local dx = mousepos.x - x
                local dz = mousepos.z - z
                local l = dx * dx + dz * dz
                if l <= 0 then
                    return inst.components.reticule.targetpos
                end
                l = 6.5 / math.sqrt(l)
                return Vector3(x + dx * l, 0, z + dz * l)
            end
        end

        inst.components.aoetargeting.reticule.updatepositionfn = function(inst, pos, reticule, ease, smoothing, dt) --- 指示特效的旋转角度控制
            local x, y, z = inst.Transform:GetWorldPosition()
            reticule.Transform:SetPosition(x, 0, z)
            local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
            if ease and dt ~= nil then
                local rot0 = reticule.Transform:GetRotation()
                local drot = rot - rot0
                rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
            end
            reticule.Transform:SetRotation(rot)
        end

        inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }    ---- 箭头指示器 变色
        inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }   ---- 箭头指示器 变色
        inst.components.aoetargeting.reticule.ease = true
        inst.components.aoetargeting.reticule.mouseenabled = true

        --------------------------------------------------------------------------------
        --- hook 官方函数,右键的时候执行 并显示指示器
            local old_aoetargeting_StartTargeting = inst.components.aoetargeting.StartTargeting
            inst.components.aoetargeting.StartTargeting = function(...)
                if ThePlayer and ThePlayer.replica.sword_fairy_com_magic_point_sys and ThePlayer.replica.sword_fairy_com_magic_point_sys:GetCurrent() >= MP_COST then
                    return old_aoetargeting_StartTargeting(...)
                end
            end
        --------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------------------------------------------------
    -----

        inst._onskillrefresh = function(owner) RefreshAttunedSkills(inst, owner) end

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "sword_fairy_weapon_flying_sword"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/sword_fairy_weapon_flying_sword.xml"

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(NORMAL_DAMAGE)

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(OnEquip)
        inst.components.equippable:SetOnUnequip(OnUnequip)

        MakeHauntableLaunch(inst)

    ------------------------------------------------------------------------------------
    ---- 技能冲击组件
        inst._cooldown = 0.1  --- 技能间隔CD
        inst.components.aoetargeting:SetEnabled(false)
        inst:AddComponent("aoeweapon_lunge")
        inst.components.aoeweapon_lunge:SetDamage(LUNGE_DAMAGE)   --- 冲刺造成的伤害
        inst.components.aoeweapon_lunge:SetSound("meta3/wigfrid/spear_lighting_lunge")
        inst.components.aoeweapon_lunge:SetSideRange(1)     --- 冲刺路线的宽度
        inst.components.aoeweapon_lunge:SetOnLungedFn(function(inst, doer, startingpos, targetpos)
            local fx = SpawnPrefab("spear_wathgrithr_lightning_lunge_fx")
            fx.Transform:SetPosition(targetpos:Get())
            fx.Transform:SetRotation(doer:GetRotation())    
            inst.components.rechargeable:Discharge(inst._cooldown)    
            inst._lunge_hit_count = nil
        end)
        inst.components.aoeweapon_lunge:SetOnHitFn(function(inst, doer, target)
            inst._lunge_hit_count = inst._lunge_hit_count or 0    
            inst._lunge_hit_count = inst._lunge_hit_count + 1
        end)
        inst.components.aoeweapon_lunge:SetStimuli("electric")
        inst.components.aoeweapon_lunge:SetWorkActions()
        inst.components.aoeweapon_lunge:SetTags("_combat")
        --------------------------------------------------------------------------------
        --- hook 执行API
            local old_aoeweapon_lunge_DoLunge = inst.components.aoeweapon_lunge.DoLunge
            inst.components.aoeweapon_lunge.DoLunge = function(self,doer,...)
                if not (doer and doer.components.sword_fairy_com_magic_point_sys) then
                    return false
                end
                if doer.components.sword_fairy_com_magic_point_sys:GetCurrent() < MP_COST then
                    return false
                end
                if old_aoeweapon_lunge_DoLunge(self,doer,...) then
                    doer.components.sword_fairy_com_magic_point_sys:DoDelta(-MP_COST)
                    return true
                end 
            end
        --------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------
    ---- 
        inst:AddComponent("aoespell")
        inst.components.aoespell:SetSpellFn(function(inst, doer, pos)
            doer:PushEvent("combat_lunge", { targetpos = pos, weapon = inst })
        end)
    ------------------------------------------------------------------------------------
    --- CD 控制组件
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetOnDischargedFn(function(inst)
            local owner = inst.components.inventoryitem:GetGrandOwner()
            inst.components.aoetargeting:SetEnabled(false)
        end)
        inst.components.rechargeable:SetOnChargedFn(function(inst)
            local owner = inst.components.inventoryitem:GetGrandOwner()
            inst.components.aoetargeting:SetEnabled(true)
        end)
    ------------------------------------------------------------------------------------

    return inst
end
------------------------------------------------------------------------------------------------------------------------


return Prefab("sword_fairy_weapon_flying_sword",fn,assets)