----------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
----------------------------------------------------------------------------------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/sword_fairy_food_tincture.zip"), 
    Asset( "IMAGE", "images/inventoryimages/sword_fairy_food_tincture.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/sword_fairy_food_tincture.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sword_fairy_food_tincture") -- 地上动画
    inst.AnimState:SetBuild("sword_fairy_food_tincture") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

    MakeInventoryFloatable(inst)
    inst:AddTag("preparedfood")
    inst:AddTag("sword_fairy_wine")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "sword_fairy_food_tincture"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/sword_fairy_food_tincture.xml"

    --------------------------------------------------------------------------
    --  
        inst:AddComponent("edible") -- 可食物组件
        inst.components.edible.foodtype = FOODTYPE.GOODIES
        inst.components.edible:SetOnEatenFn(function(inst,eater)
            if eater and eater:HasTag("player") and eater:HasTag("sword_fairy_sky_truly") then
                -- print("+++++++++++++++++++",inst,eater)
                eater.components.sword_fairy_com_drunkenness:DoDelta(7)
                eater.components.sword_fairy_com_data:Set("sword_fairy_food_tincture_hunger",70)
                eater.components.sword_fairy_com_data:Set("sword_fairy_food_tincture_hunger_max",70)
                while true do
                    local debuff = eater:GetDebuff("sword_fairy_debuff_tincture")
                    if debuff and debuff:IsValid() then
                        return
                    end
                    eater:AddDebuff("sword_fairy_debuff_tincture","sword_fairy_debuff_tincture")
                end
            end
        end)
        inst.components.edible.hungervalue = 0
        inst.components.edible.sanityvalue = 1
        inst.components.edible.healthvalue = 1
    --------------------------------------------------------------------------
    --- 
        inst:AddComponent("stackable") -- 可堆叠
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
        inst:AddComponent("tradable")
        MakeHauntableLaunch(inst)
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

return Prefab("sword_fairy_food_tincture", fn, assets)