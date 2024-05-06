--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local RANGE = 15
    local RANGE_SQUARED = RANGE*RANGE
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local farm_tile_fn = function(pt,_cmd_table)
                
        -----------------------------------------------------------------------
        --- 控制表
            _cmd_table = _cmd_table or {}
            local farm_soil_flag = _cmd_table.farm_soil_flag or false
            local fertilize_flag = _cmd_table.fertilize_flag or false
            local watering_can_flag = _cmd_table.watering_can_flag or false
        -----------------------------------------------------------------------
        --- 初始化 flag 表
            local map_width,map_height = TheWorld.Map:GetSize()
            local function init_tile_flags()
                local tile_flags = {}
                for x=1,map_width,1 do
                    for y=1,map_height,1 do
                        tile_flags[x] = tile_flags[x] or {}
                        tile_flags[x][y] = false
                    end
                end
                return tile_flags
            end
            
        -----------------------------------------------------------------------
        --- 输入地块的 XY 得到这个地块中心的 世界坐标Vector3()
            local function GetWorldPointByTileXY(x,y,map_width,map_height)
                if map_width == nil or map_height == nil then
                    map_width,map_height = TheWorld.Map:GetSize()
                end
                local ret_x = x - map_width/2
                local ret_z = y - map_height/2
                return Vector3(ret_x*TILE_SCALE,0,ret_z*TILE_SCALE)
            end
        -----------------------------------------------------------------------
        --- 获取环绕坐标
            local function GetSurroundPoints(CMD_TABLE)
                -- local CMD_TABLE = {
                --     target = inst or Vector3(),
                --     range = 8,
                --     num = 8
                -- }
                if CMD_TABLE == nil then
                    return
                end
                local theMid = nil
                if CMD_TABLE.target == nil then
                    theMid = Vector3( self.inst.Transform:GetWorldPosition() )
                elseif CMD_TABLE.target.x then
                    theMid = CMD_TABLE.target
                elseif CMD_TABLE.target.prefab then
                    theMid = Vector3( CMD_TABLE.target.Transform:GetWorldPosition() )
                else
                    return
                end   
                local num = CMD_TABLE.num or 8
                local range = CMD_TABLE.range or 8
                local retPoints = {}
                for i = 1, num, 1 do
                    local tempDeg = (2*PI/num)*(i-1)
                    local tempPoint = theMid + Vector3( range*math.cos(tempDeg) ,  0  ,  range*math.sin(tempDeg)    )
                    table.insert(retPoints,tempPoint)
                end    
                return retPoints    
            end
        -----------------------------------------------------------------------
            local tile_flags = init_tile_flags()


            local temp_points = nil
        -----------------------------------------------------------------------
        --- 圈圈范围覆盖内的地块。用脚踩扫描。
            local test_range = RANGE
            while test_range > 2 do
                temp_points = GetSurroundPoints({
                    target = pt,
                    range = test_range,
                    num = 30
                })
                for i,temp_pt in pairs(temp_points) do
                    local tile_x,tile_y =  TheWorld.Map:GetTileXYAtPoint(temp_pt.x,0,temp_pt.z)
                    tile_flags[tile_x][tile_y] = Vector3(TheWorld.Map:GetTileCenterPoint(temp_pt.x,0,temp_pt.z))
                end
                test_range = test_range - 2
            end
        -----------------------------------------------------------------------
        --- 扫描flag表 并在合适位置生成特效
            for x = 1, map_width, 1 do
                for y = 1, map_height, 1 do
                    if tile_flags[x][y] then
                        -------------------------------------------------------------------------
                        --- 参数表
                            local tile_mid_pt = tile_flags[x][y]
                            local is_farm_tile = TheWorld.Map:GetTileAtPoint(tile_mid_pt.x,0,tile_mid_pt.z) == WORLD_TILES.FARMING_SOIL or false
                        -------------------------------------------------------------------------
                            SpawnPrefab("sword_fairy_sfx_tile_outline"):PushEvent("Set",{
                                pt = tile_flags[x][y],
                                color = is_farm_tile and Vector3(0,255,0) or Vector3(100,100,100),
                                a = is_farm_tile and 1 or 0.2,
                                MultColour_Flag = true,
                                fn = function(fx)
                                    fx:DoTaskInTime(5,fx.Remove)
                                    if is_farm_tile then
                                        -------------------------------------------------------------------------
                                        --- 添加水分
                                            if watering_can_flag then
                                                TheWorld.components.farming_manager:AddSoilMoistureAtPoint(tile_mid_pt.x, 0, tile_mid_pt.z, 100)
                                            end
                                        -------------------------------------------------------------------------
                                        --- 给地块施肥（3种）
                                            if fertilize_flag then
                                                TheWorld.components.farming_manager:AddTileNutrients(x, y,100,100,100)
                                            end
                                        -------------------------------------------------------------------------
                                        ---- 清除垃圾
                                            if farm_soil_flag then
                                                local need_2_remove_prefabs = {
                                                    ["farm_soil"] = true,   --- 没放种子的土坑
                                                    ["farm_soil_debris"] = true,  --- 垃圾物品
                                                }
                                                local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(tile_mid_pt.x, 0,tile_mid_pt.z)
                                                for k, tempInst in pairs(ents) do
                                                    -- print(k,tempInst)
                                                    if need_2_remove_prefabs[tempInst.prefab] then
                                                        tempInst:Remove()
                                                    end
                                                end
                                            end
                                        -------------------------------------------------------------------------
                                        ---- 开始挖坑
                                            if farm_soil_flag then
                                                local soil_delta = 4/3
                                                local soil_delta_sq = soil_delta*soil_delta
                                                local function CanPlantAtPoint(x,y,z)
                                                    if not TheWorld.Map:IsFarmableSoilAtPoint(x, 0,z) then
                                                        return false
                                                    end
                                                    local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(x, 0,z)
                                                    for k, temp_inst in pairs(ents) do
                                                        if temp_inst:HasOneOfTags({"plant","farm_plant"}) and temp_inst:GetDistanceSqToPoint(x, 0,z) < soil_delta_sq then
                                                            return false
                                                        end
                                                    end
                                                    return true
                                                end
                                                local pt_offsets = {
                                                    Vector3(-soil_delta,0,-soil_delta) , Vector3(0,0,-soil_delta) , Vector3(soil_delta,0,-soil_delta) ,
                                                    Vector3(-soil_delta,0,   0  ) , Vector3(0,0,0) , Vector3(soil_delta,0,0) ,
                                                    Vector3(-soil_delta,0,soil_delta) , Vector3(0,0,soil_delta) , Vector3(soil_delta,0,soil_delta) ,
                                                }
                                                for k, temp_offset in pairs(pt_offsets) do
                                                    local temp_x = tile_mid_pt.x + temp_offset.x
                                                    local temp_y = tile_mid_pt.y + temp_offset.y
                                                    local temp_z = tile_mid_pt.z + temp_offset.z
                                                    if CanPlantAtPoint(temp_x, 0,temp_z) then
                                                        SpawnPrefab("farm_soil").Transform:SetPosition(temp_x,0,temp_z)
                                                    end
                                                end
                                            end
                                        -------------------------------------------------------------------------
                                    end
                                end
                            })
                        -------------------------------------------------------------------------
                    end
                end
            end
        -----------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
                farm_tile_fn(pt,{
                    fertilize_flag = true,
                })
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["fertilize"]["mp_cost"])
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
                farm_tile_fn(pt,{
                    farm_soil_flag = true,
                })
                doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["hoe"]["mp_cost"])
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
        ["watering_can"] = function(inst,doer,pt) --- 浇水壶
                print("watering_can  work : ",doer,pt)
                ---------------------------------------------------------------------------------------------------------
                ---- 灭火
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
                ---------------------------------------------------------------------------------------------------------
                ---- 农田加水                
                    farm_tile_fn(pt,{
                        watering_can_flag = true,
                    })
                ---------------------------------------------------------------------------------------------------------
                ---- 耗蓝
                    doer.components.sword_fairy_com_magic_point_sys:DoDelta(-SPELL_PARAM["watering_can"]["mp_cost"])
                ---------------------------------------------------------------------------------------------------------

        end,
    }

end