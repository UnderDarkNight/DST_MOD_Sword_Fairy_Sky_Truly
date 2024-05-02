local assets = {
	Asset("ANIM", "anim/sword_fairy_weapon_flying_sword.zip"),
}

--------------------------------------------------------------------------------------------------------------------------------------------------------
---- 剑光
    local function fx_idle()
        local inst = CreateEntity()

        inst.entity:AddSoundEmitter()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetBank("sword_fairy_weapon_flying_sword")
        inst.AnimState:SetBuild("sword_fairy_weapon_flying_sword")
        inst.AnimState:PlayAnimation("fx_idle", true)

        -- inst.AnimState:SetSortOrder(1)

        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        inst:AddTag("NOBLOCK")

        -- inst:ListenForEvent("animover",inst.Remove)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:ListenForEvent("up",function(inst,fn)
            inst.Ready = true
            inst.anim_over_fn = function(inst)
                if type(fn) == "function" then
                    pcall(fn,inst)
                end
                inst:RemoveEventCallback("animover",inst.anim_over_fn)
            end
            inst.AnimState:PlayAnimation("fx_leave", false)
            inst:ListenForEvent("animover",inst.anim_over_fn)
        end)

        inst:ListenForEvent("down",function(inst,fn)
            inst.Ready = true
            inst.anim_over_fn = function(inst)
                if type(fn) == "function" then
                    pcall(fn,inst)
                end
                inst:RemoveEventCallback("animover",inst.anim_over_fn)
                inst.AnimState:PlayAnimation("fx_idle", true)
            end
            inst.AnimState:PlayAnimation("fx_join", false)
            inst:ListenForEvent("animover",inst.anim_over_fn)
        end)

        ----- 离开
            inst:ListenForEvent("leave",function(inst,animover_fn)
                inst.Ready = true
                inst:PushEvent("up",function(inst)
                    inst:Hide()
                    animover_fn(inst)
                end)
            end)
        ----- 进入
            inst:ListenForEvent("join",function(inst,animover_fn)
                inst.Ready = true
                inst:Show()
                inst:PushEvent("down",animover_fn)
            end)
        --- hide/show
            inst:ListenForEvent("hide",function()
                inst.Ready = true
                inst:Hide() 
            end)            
            inst:ListenForEvent("show",function()
                inst.Ready = true
                inst:Show()
            end)
        ---- 移除意外情况的残留
            inst:DoTaskInTime(0,function()
                if not inst.Ready then
                    inst:Remove()
                end
            end)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------
---- 圆环    
    local function cycle_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("sword_fairy_weapon_flying_sword")
        inst.AnimState:SetBuild("sword_fairy_weapon_flying_sword")
        local scale_num = 1.5
        inst.AnimState:SetScale(scale_num, scale_num, scale_num)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        -- inst.AnimState:SetSortOrder(0)
        inst.AnimState:PlayAnimation("cycle",true)
        
        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")      --- 不可点击
        -- inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
        inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
        -- inst.Transform:SetRotation(math.random(350))

        inst.AnimState:HideSymbol("cycle")
        inst.AnimState:HideSymbol("pt_1")
        inst.AnimState:HideSymbol("pt_2")
        inst.AnimState:HideSymbol("pt_3")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

            
        

        local function create_swords(inst)

            local y = 0
            local fx_1 = SpawnPrefab("sword_fairy_sfx_sword_idle")
            -- fx_1.entity:SetParent(inst.entity)  --- 【笔记】这句不是必须，某些旋转角度会导致丢失
            fx_1.entity:AddFollower()
            fx_1.Follower:FollowSymbol(inst.GUID, "pt_1", 0, y, 0)

            local fx_2 = SpawnPrefab("sword_fairy_sfx_sword_idle")
            -- fx_2.entity:SetParent(inst.entity)
            fx_2.entity:AddFollower()
            fx_2.Follower:FollowSymbol(inst.GUID, "pt_2", 0, y, 0)

            local fx_3 = SpawnPrefab("sword_fairy_sfx_sword_idle")
            -- fx_3.entity:SetParent(inst.entity)
            fx_3.entity:AddFollower()
            fx_3.Follower:FollowSymbol(inst.GUID, "pt_3", 0, y, 0)


            fx_1:ListenForEvent("onremove",function()
                fx_1:Remove()
            end,inst)
            fx_2:ListenForEvent("onremove",function()
                fx_2:Remove()
            end,inst)
            fx_3:ListenForEvent("onremove",function()
                fx_3:Remove()
            end,inst)




            inst.sword = {}

            inst.sword[1] = fx_1
            inst.sword[2] = fx_2
            inst.sword[3] = fx_3

            inst:ListenForEvent("sword",function(inst,_table)
                local num = _table.num
                local fn = _table.fn or function(...)                end
                num = math.clamp(num,1,3)
                fn(inst.sword[num])
            end)

        end
        -- create_swords(inst)
        inst:ListenForEvent("Set",function()
            create_swords(inst)
            inst.Ready = true
        end)

        
        inst:DoTaskInTime(0,function()
            if not inst.Ready then
                inst:Remove()
            end
        end)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("sword_fairy_sfx_sword_idle",fx_idle,assets),
    Prefab("sword_fairy_sfx_sword_cycle",cycle_fn,assets)