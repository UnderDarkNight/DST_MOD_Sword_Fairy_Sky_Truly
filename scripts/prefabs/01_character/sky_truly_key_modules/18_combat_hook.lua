--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    ------------------------------------------------------------------------------------------------------------
    --- 参数表
        local MP_COST = 7
        if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
            MP_COST = 0
        end
    ------------------------------------------------------------------------------------------------------------

    inst:ListenForEvent("master_postinit_sword_fairy_sky_truly", function(inst)


        if inst.components.combat == nil then
            return
        end


        local old_GetAttacked_fn = inst.components.combat.GetAttacked
        inst.components.combat.GetAttacked = function(self,attacker, damage, weapon, stimuli, spdamage,...)
            
            if inst:HasTag("spriter_hat_active") then
                ------------------------------------------------------------------------------------------------------------
                --- 在头上的时候
                    local spriter = inst:GetSpriter()
                    if spriter then
                        local mp_in_spriter = spriter.components.sword_fairy_com_magic_point_sys:GetCurrent()
                        if mp_in_spriter >= MP_COST then
                                spriter.components.sword_fairy_com_magic_point_sys:DoDelta(-MP_COST)
                                damage = 0
                                if spdamage then
                                    spdamage = 0
                                end
                        end
                    end
                ------------------------------------------------------------------------------------------------------------
            else
                ------------------------------------------------------------------------------------------------------------
                --- 不在头上的时候
                    local spriter = inst:GetSpriter()
                    if spriter then
                        if spriter.components.sword_fairy_com_data:Get("block_for_player_flag") ~= TheWorld.state.cycles then

                            spriter.components.sword_fairy_com_data:Set("block_for_player_flag",TheWorld.state.cycles)
                            damage = 0
                            if spdamage then
                                spdamage = 0
                            end
                            spriter:PushEvent("say_block_for_player_per_day")
                        else
                            ---- 常驻伤害减少7点
                            if damage > 7 then
                                damage = damage - 7
                            else
                                damage = 0
                            end
                           
                        end
                    end
                ------------------------------------------------------------------------------------------------------------
            end


            return old_GetAttacked_fn(self,attacker, damage, weapon, stimuli, spdamage,...)
        end














    end)
end