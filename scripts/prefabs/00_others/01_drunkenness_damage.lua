--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    用来处理死亡通告的 死亡原因用的
    
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end



    inst:AddComponent("inspectable")


    return inst
end

return Prefab("sword_fairy_other_drunkenness_damage", fn, assets)
