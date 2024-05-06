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

-- local function onequip(inst, owner)
--     owner.AnimState:OverrideSymbol("swap_object", "sword_fairy_weapon_flying_sword_swap", "swap_object")
--     owner.AnimState:Show("ARM_carry")
--     owner.AnimState:Hide("ARM_normal")
--     if owner:HasTag("player") then
--         owner:PushEvent("sword_fairy_weapon_flying_sword.equip")
--     end
-- end

-- local function onunequip(inst, owner)
--     owner.AnimState:ClearOverrideSymbol("swap_object")
--     owner.AnimState:Hide("ARM_carry")
--     owner.AnimState:Show("ARM_normal")
--     if owner:HasTag("player") then
--         owner:PushEvent("sword_fairy_weapon_flying_sword.unequip")
--     end
-- end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- MakeInventoryPhysics(inst)

    -- inst.AnimState:SetBank("sword_fairy_weapon_flying_sword")
    -- inst.AnimState:SetBuild("sword_fairy_weapon_flying_sword")
    -- inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("weapon")
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOBLOCK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(7)
    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(7)


    return inst
end

return Prefab("sword_fairy_flying_sword_for_fx_damage", fn, assets)
