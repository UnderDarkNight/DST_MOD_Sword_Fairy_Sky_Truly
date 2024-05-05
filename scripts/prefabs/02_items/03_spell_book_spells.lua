

local RANGE = 15


return function(SPELL_PARAM)        
    return {
            ["axe"] = function(inst,doer,pt)
                -- print("axe  work : ",doer,pt)
                local musthavetags = { "CHOP_workable" }
                local canthavetags = { "burnt" }
                local musthaveoneoftags = nil
                local ents = TheSim:FindEntities(pt.x,0,pt.z,RANGE,musthavetags,canthavetags,musthaveoneoftags)
                for i,tree in ipairs(ents) do
                    if tree and tree:IsValid() and tree.components.workable and tree.components.workable:CanBeWorked() then
                        tree.components.workable:Destroy(doer)
                    end
                end

                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["axe"]["mp_cost"])

            end,
            ["cookpot"] = function(inst,doer,pt)
                -- print("cookpot  work : ",doer,pt)
                if doer.components.sword_fairy_com_fast_cooker then
                    doer.components.sword_fairy_com_fast_cooker:DoDelta(7)
                end
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["cookpot"]["mp_cost"])

            end,
        ["fertilize"] = function(inst,doer,pt)
                print("fertilize  work : ",doer,pt)
        end,
        ["hammer"] = function(inst,doer,pt)
                -- print("hammer  work : ",doer,pt)
                local musthavetags = { "HAMMER_workable" }
                local canthavetags = nil
                local musthaveoneoftags = nil
                local ents = TheSim:FindEntities(pt.x,0,pt.z,RANGE,musthavetags,canthavetags,musthaveoneoftags)
                for i,target in ipairs(ents) do
                    if target and target:IsValid() and target.components.workable and target.components.workable:CanBeWorked() then
                        target.components.workable:Destroy(doer)
                    end
                end
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["hammer"]["mp_cost"])
        end,
        ["hoe"] = function(inst,doer,pt)
                print("hoe  work : ",doer,pt)
        end,
        ["living_log"] = function(inst,doer,pt)
                print("living_log  work : ",doer,pt)
                local musthavetags = { "pickable" }
                local canthavetags = {"burnt"}
                local musthaveoneoftags = nil
                local ents = TheSim:FindEntities(pt.x,0,pt.z,RANGE,musthavetags,canthavetags,musthaveoneoftags)
                for i,target in ipairs(ents) do
                    if target and target:IsValid() and target.components.pickable and target.components.pickable:CanBePicked() then
                        target.components.pickable:Pick(doer)
                    end
                end
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["living_log"]["mp_cost"])
        end,
        ["map_blink"] = function(inst,doer,pt)
                print("map_blink  work : ",doer,pt)
                doer.components.sword_fairy_com_map_jumper:DoDelta(3)
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["map_blink"]["mp_cost"])
        end,
        ["pickaxe"] = function(inst,doer,pt)
                print("pickaxe  work : ",doer,pt)
                local musthavetags = { "MINE_workable" }
                local canthavetags = nil
                local musthaveoneoftags = nil
                local ents = TheSim:FindEntities(pt.x,0,pt.z,RANGE,musthavetags,canthavetags,musthaveoneoftags)
                for i,target in ipairs(ents) do
                    if target and target:IsValid() and target.components.workable and target.components.workable:CanBeWorked() then
                        target.components.workable:Destroy(doer)
                    end
                end
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["pickaxe"]["mp_cost"])
        end,
        ["shovel"] = function(inst,doer,pt)  ---- 铲子
                print("shovel  work : ",doer,pt)
                local musthavetags = { "DIG_workable" }
                local canthavetags = nil
                local musthaveoneoftags = nil
                local ents = TheSim:FindEntities(pt.x,0,pt.z,RANGE,musthavetags,canthavetags,musthaveoneoftags)
                for i,target in ipairs(ents) do
                    if target and target:IsValid() and target.components.workable and target.components.workable:CanBeWorked() then
                        target.components.workable:Destroy(doer)
                    end
                end
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["shovel"]["mp_cost"])
        end,
        ["watering_can"] = function(inst,doer,pt)
                print("watering_can  work : ",doer,pt)

                local musthavetags = nil
                local canthavetags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "burnt", "player", "monster" }
                local musthaveoneoftags = {"fire", "smolder"}
                local ents = TheSim:FindEntities(pt.x,0,pt.z,RANGE,musthavetags,canthavetags,musthaveoneoftags)
                for i,target in ipairs(ents) do
                    if target and target:IsValid() and target.components.burnable and 
                        ( target.components.burnable:IsBurning() or target.components.burnable:IsSmoldering() ) then

                            target.components.burnable:Extinguish(true)

                    end
                end
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["shovel"]["mp_cost"])
        end,
    }

end