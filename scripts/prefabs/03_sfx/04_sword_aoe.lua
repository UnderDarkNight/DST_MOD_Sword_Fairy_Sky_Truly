local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	Asset("ANIM", "anim/sword_fairy_fx_sword_aoe.zip"),
}


local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("sword_fairy_fx_sword_aoe")
    inst.AnimState:SetBuild("sword_fairy_fx_sword_aoe")
    -- inst.AnimState:PlayAnimation("idle", false)
    -- inst.AnimState:SetFinalOffset(1)
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num, scale_num, scale_num)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    -- inst:AddTag("CLASSIFIED")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     target = inst,
        --     speed = 1,
        --     sound = "",
        --     fn = function()end,
        --     on_hit_fn = function()end,
        --     animover_fn = function()end,
        --
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end
        ------------------------------------------------------------------------------------------------------------------------------------

        ------------------------------------------------------------------------------------------------------------------------------------
        if _table.sound then
            inst.SoundEmitter:PlaySound(_table.sound)
        end

        if type(_table.speed) == "number" then
            inst.AnimState:SetDeltaTimeMultiplier(_table.speed)
        end

        local fn = _table.fn or function()        end
        local on_hit_fn = _table.on_hit_fn or function()        end
        local animover_fn = _table.animover_fn or function()        end
        inst.AnimState:PlayAnimation("idle", false)
        inst:ListenForEvent("animover",function()
            pcall(fn)
            pcall(animover_fn)
            inst:Remove()
        end)
        inst:DoTaskInTime(0.15,function()
            pcall(on_hit_fn)
        end)

        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("sword_fairy_sfx_flying_sword_aoe",fx,assets)