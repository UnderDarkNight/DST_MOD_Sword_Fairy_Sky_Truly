--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    潮湿度 moisture

    常驻 7%潮湿度增长抵抗

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_sword_fairy_sky_truly",function()
        

        if inst.components.moisture == nil then
            return
        end

        local old_DoDelta = inst.components.moisture.DoDelta
        inst.components.moisture.DoDelta = function(self,num,...)
            if num > 0 then
                num = num * (1-0.07)
            end
            return old_DoDelta(self,num,...)
        end


    end)
end