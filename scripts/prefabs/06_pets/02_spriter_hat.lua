local assets =
{
    Asset("ANIM", "anim/sword_fairy_spriter.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("sword_fairy_spriter")
    inst.AnimState:SetBuild("sword_fairy_spriter")
    inst.AnimState:PlayAnimation("hat",true)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end
return Prefab("sword_fairy_spriter_hat", fn, assets)