--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    保鲜组件

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    ------------------------------------------------------------------------------------------------------------
    --- 保鲜
        if TheWorld.ismastersim then
            inst:AddComponent("preserver")  --- 官方保鲜/返鲜组件
            -- inst.components.preserver.perish_rate_multiplier = function(inst,item)
            --     --- 新鲜值 降低倍数
            --     return 2
            -- end
            inst.components.preserver.perish_rate_multiplier = 0.1
        end
    ------------------------------------------------------------------------------------------------------------
end