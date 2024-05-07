------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    飞剑

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{

}



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


    inst.entity:SetPristine()
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --
        local ClientSideMouseOverFn = function(inst,doer)
            if not ( ThePlayer and ThePlayer == doer and doer:HasTag("sword_fairy_sky_truly") ) then
                return
            end
            if inst.__high_light_task ~= nil then
                inst.__high_light_task:Cancel()
                inst.__high_light_task = nil
            end
            inst.__high_light_task = inst:DoTaskInTime(5,function()
                inst.__high_light_task = nil
                inst.AnimState:SetScale(1,1,1)
            end)
            inst.AnimState:SetScale(3,3,3)
        end
        inst:ListenForEvent("sword_fairy_event.OnEntityReplicated.sword_fairy_com_workable",function(inst,replica_com)
            replica_com:SetText("sword_fairy_book_encyclopedia",STRINGS.ACTIONS.GIVE.READY)
            replica_com:SetTestFn(function(inst,doer)
                ---------------------------------------------------------------
                ClientSideMouseOverFn(inst,doer)
                ---------------------------------------------------------------
                return false
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("sword_fairy_com_workable")
            inst.components.sword_fairy_com_workable:SetActiveFn(function(inst,doer)
                return true
            end)
        end
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")


    return inst
end
return Prefab("sword_fairy_weapon_test_high_light", fn, assets)
