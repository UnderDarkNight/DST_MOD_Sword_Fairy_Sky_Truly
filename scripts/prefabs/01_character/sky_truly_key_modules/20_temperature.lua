--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    温度组件， 舒适温度： 35

    过热温度，70
    过冷温度：0

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_sword_fairy_sky_truly",function()
        

        if inst.components.temperature == nil then
            return
        end



        local mult_num = 1 - 0.07

        local old_DoDelta = inst.components.temperature.DoDelta
        inst.components.temperature.DoDelta = function(self,num,...)
            local over_heat_temperature = self.overheattemp
            local over_cold_temperature = 0
            local comfort_temperature = (over_cold_temperature + over_heat_temperature)/2
            local current_temperature = self:GetCurrent()
            
            if current_temperature > comfort_temperature and num > 0 then
                num = num * mult_num
            elseif current_temperature < comfort_temperature and num < 0 then
                num = num * mult_num
            end
            return old_DoDelta(self,num,...)
        end


    end)
end