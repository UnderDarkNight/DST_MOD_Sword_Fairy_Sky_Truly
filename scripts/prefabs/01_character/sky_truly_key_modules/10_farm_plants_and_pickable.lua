--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【丰饶】
        解锁条件【收获7个农田作物（耕地出来的）】
        解锁后【采摘有7%概率多1个果实】


    -- :PushEvent("picked", { picker = picker, loot = loot, plant = self.inst })

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 判定目标是否是 种植作物
    local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
    local function TargetIsFarmPlant(target)
        if target and target.prefab then
            for veggie, veggie_data in pairs(PLANT_DEFS) do
                -- print(veggie_data.prefab)
                if veggie_data.prefab == target.prefab then
                    return true
                end
            end
        end
        return false
    end
    local function pickable_loot_get_inst(loot)
        if loot.prefab then
            return loot
        end
        for k, temp_inst in pairs(loot) do
            if temp_inst and temp_inst.prefab then
                return temp_inst
            end
        end
        return nil
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local com_data = inst.components.sword_fairy_com_data
    local index = "FARM_PLANT_PICKED"

    inst:ListenForEvent("picksomething",function(inst,_table)
        _table = _table or {}
        local target_plant = _table.object or inst
        local loot = _table.loot
        -- print("+++++++++++++++++++++++++++++")
        -- print(target_plant,loot)
        -- for k, v in pairs(loot) do
        --     print(k,v)
        -- end
        -- print("+++++++++++++++++++++++++++++")

        if com_data:Add(index, 0) >= 7 then
            ------------------------------------------------------------
            ----
                if math.random(1000) > (TUNING.sword_fairy_sky_truly_DEBUGGING_MODE and 1000 or 70 ) then
                    return
                end
                if not (loot) then
                    return
                end
                loot = pickable_loot_get_inst(loot)
                if not (loot) then
                    return
                end
                if loot.components.stackable then   --- 可叠堆的时候直接 叠
                    loot.components.stackable.stacksize = loot.components.stackable.stacksize + 1
                else    --- 不可叠堆的时候 直接 生成
                    local x,y,z = inst.Transform:GetWorldPosition()
                    SpawnPrefab(loot.prefab).Transform:SetPosition(x,y,z)
                end
            ------------------------------------------------------------
        elseif TargetIsFarmPlant(target_plant) then
            com_data:Add(index, 1)
        end

    end)


end