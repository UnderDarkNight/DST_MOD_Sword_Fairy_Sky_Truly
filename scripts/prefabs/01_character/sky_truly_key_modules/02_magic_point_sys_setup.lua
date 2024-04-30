--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    安装 MP 系统，和对应的位面防御/伤害 系统

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    -------------------------------------------------------------------------
    --- 创建挂载inst
        local mp_inst = CreateEntity()
        mp_inst:ListenForEvent("onremove",function()
            mp_inst:Remove()
        end,inst)
    -------------------------------------------------------------------------


    inst:AddComponent("sword_fairy_com_magic_point_sys")
    inst.components.sword_fairy_com_magic_point_sys.current = 7
    inst.components.sword_fairy_com_magic_point_sys.max = 7


    -------------------------------------------------------------------------------------------------------
    ---- 位面伤害/防御
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(0)
        local base_planardefense = 7
        inst:AddComponent("planardefense")
	    inst.components.planardefense:SetBaseDefense(base_planardefense)
    -------------------------------------------------------------------------------------------------------
    --- 每7点法力值上限(向下取整）、防御增加1%，最高99%    每49点法力值上限，攻击、速度增加1%，位面攻击、位面防御增加1
        local function mp_max_update_fn()
            local max = inst.components.sword_fairy_com_magic_point_sys.max
            local current = inst.components.sword_fairy_com_magic_point_sys.current


            ---- 每7点法力值上限，防御增加1% 。按等级向下取整 。最高99%
                local base_dmg_taken_mult = 0.93  --- 默认7% 的基础防御
                local dmg_taken_mult= math.floor(max/7)*0.01
                ----- 按照设置更改上限
                local max_dmg_taken_mult = TUNING["sword_fairy_sky_truly.Config"] and TUNING["sword_fairy_sky_truly.Config"].MP_Limit_and_Defense or 0.5
                if dmg_taken_mult > max_dmg_taken_mult then
                    dmg_taken_mult = max_dmg_taken_mult
                end

                local ret_dmg_taken_mult = base_dmg_taken_mult - dmg_taken_mult
                inst.components.combat.externaldamagetakenmultipliers:SetModifier(mp_inst,ret_dmg_taken_mult)
                
            ---- 49 法力值上限为 1 level
                local temp_level = math.floor(max/49)
                ---- 移动速度
                    inst.components.locomotor:SetExternalSpeedMultiplier(mp_inst, "sword_fairy_sky_truly_speed_by_max_mp", 1+temp_level*0.01)
                ---- 攻击力
                    inst.components.combat.externaldamagemultipliers:SetModifier(mp_inst,1+temp_level*0.01)
                ---- 位面伤害
                    inst.components.planardamage:SetBaseDamage(temp_level)
                ---- 位面防御
                    inst.components.planardefense:SetBaseDefense(base_planardefense + temp_level)

        end
        inst.components.sword_fairy_com_magic_point_sys:AddOnLoadFn(mp_max_update_fn)
        inst:ListenForEvent("magic_point_dodelta_max", mp_max_update_fn)
    -------------------------------------------------------------------------------------------------------
    ---- 法力值的恢复：hunger每消耗7点，恢复1点法力值。hunger每消耗490点，增加1点法力值上限。
        inst:ListenForEvent("hungerdelta",function(inst,_table)
            if not (_table and _table.delta) then
                return
            end
            if _table.delta >= 0 then
                return
            end

            local mp_delta_by_hunger = inst.components.sword_fairy_com_data:Add("mp_delta_by_hunger",math.abs(_table.delta))
            if mp_delta_by_hunger >= 7 then
                local mp_up_mult = 1
                if inst.components.sword_fairy_com_drunkenness:IsIntoxicated() then --- 醉醺醺状态 法力恢复X3
                    mp_up_mult = 3
                end
                inst.components.sword_fairy_com_magic_point_sys:DoDelta(1*mp_up_mult)
                inst.components.sword_fairy_com_data:Add("mp_delta_by_hunger",-7)
            end

            local mp_max_delta_by_hunger = inst.components.sword_fairy_com_data:Add("mp_max_delta_by_hunger",math.abs(_table.delta))
            if mp_max_delta_by_hunger >= 490 then
                inst.components.sword_fairy_com_magic_point_sys:DoDeltaMax(1)
                inst.components.sword_fairy_com_data:Add("mp_max_delta_by_hunger",-490)
            end

        end)
    -------------------------------------------------------------------------------------------------------
    ---- 战斗时饥饿消耗速率为3倍。移步到 03_eater_and_hunger.lua
    -------------------------------------------------------------------------------------------------------

end