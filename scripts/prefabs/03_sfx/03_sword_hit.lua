local assets = {

	Asset("ANIM", "anim/sword_fairy_weapon_flying_sword.zip"),
}


local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("sword_fairy_weapon_flying_sword")
    inst.AnimState:SetBuild("sword_fairy_weapon_flying_sword")
    -- inst.AnimState:PlayAnimation("fx_hit", false)
    -- inst.AnimState:PushAnimation("fx_hit_pst", false)



    inst:AddTag("CLASSIFIED")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")

    -- inst:ListenForEvent("animover",inst.Remove)
    -- inst:ListenForEvent("animqueueover",inst.Remove)

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
        --     onhit_fn = function() end,
        --     on_leave_fn = function() end,
        -- }
        ------------------------------------------------------------------------------------------------------------------------------------
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end
        if _table.target then
            inst.Transform:SetPosition(_table.target.Transform:GetWorldPosition())
        end
        ------------------------------------------------------------------------------------------------------------------------------------
        
        if _table.sound then
            inst.SoundEmitter:PlaySound(_table.sound)
        end

        if type(_table.speed) == "number" then
            inst.AnimState:SetDeltaTimeMultiplier(_table.speed)
        end
        ------------------------------------------------------------------------------------------------------------------------------------
            local onhit_fn = _table.onhit_fn or function(...) end
            local on_leave_fn = _table.on_leave_fn or function(...) end
            inst.anim_over_fn = function(...)
                onhit_fn(inst)
                inst:RemoveEventCallback("animover",inst.anim_over_fn)


                inst.anim_over_fn = function()
                    inst:RemoveEventCallback("animover",inst.anim_over_fn)
                    inst.anim_over_fn = function()
                        inst:RemoveEventCallback("animover",inst.anim_over_fn)
                        on_leave_fn(inst)
                        inst:Remove()
                    end
                    inst.AnimState:PlayAnimation("fx_leave",false)
                    inst:ListenForEvent("animover",inst.anim_over_fn)
                end

                inst.AnimState:PlayAnimation("fx_hit_pst",false)
                inst:ListenForEvent("animover",inst.anim_over_fn)

            end
            inst.AnimState:PlayAnimation("fx_hit", false)
            inst:ListenForEvent("animover",inst.anim_over_fn)
        ------------------------------------------------------------------------------------------------------------------------------------

        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("sword_fairy_sfx_flying_sword_hit",fx,assets)