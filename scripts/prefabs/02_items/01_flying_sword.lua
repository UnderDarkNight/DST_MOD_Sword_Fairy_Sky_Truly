------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    飞剑

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/sword_fairy_weapon_flying_sword.zip"),
    Asset("ANIM", "anim/sword_fairy_weapon_flying_sword_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/sword_fairy_weapon_flying_sword.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/sword_fairy_weapon_flying_sword.xml" ),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "sword_fairy_weapon_flying_sword_swap", "swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if owner:HasTag("player") then
        owner:PushEvent("sword_fairy_weapon_flying_sword.equip")
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if owner:HasTag("player") then
        owner:PushEvent("sword_fairy_weapon_flying_sword.unequip")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sword_fairy_weapon_flying_sword")
    inst.AnimState:SetBuild("sword_fairy_weapon_flying_sword")
    inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("weapon")
    inst:AddTag("sword_fairy_weapon_flying_sword")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)
    inst.components.weapon:SetOnAttack(function(inst, attacker, target)
        attacker:PushEvent("flying_sword_on_hit_target",{
            weapon = inst,
            attacker = attacker,
            target = target,
        })
    end)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sword_fairy_weapon_flying_sword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sword_fairy_weapon_flying_sword.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("sword_fairy_weapon_flying_sword", fn, assets)
