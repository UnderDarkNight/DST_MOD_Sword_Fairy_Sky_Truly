--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_sword_fairy_sky_truly",function()

        local old_GetAttacked = inst.components.combat.GetAttacked
        inst.components.combat.GetAttacked = function(self,attacker, damage, weapon, stimuli, spdamage,...)
            ---------------------------------------------------------------------------------------------
            --- 7%概率 躲避开伤害
                if math.random(1000) <= 70 then
                    damage = 0
                    local fx = inst:SpawnChild("sword_fairy_sfx_shadow_shell")
                    fx:PushEvent("Set",{
                        color = Vector3(0,100,255),
                        a = 0.5,
                        speed = 2,
                        MultColour_Flag = true,
                    })
                    if spdamage ~= nil then
                        spdamage = 0
                    end
                end
            ---------------------------------------------------------------------------------------------
            return old_GetAttacked(self,attacker, damage, weapon, stimuli, spdamage,...)
        end

    end)
end