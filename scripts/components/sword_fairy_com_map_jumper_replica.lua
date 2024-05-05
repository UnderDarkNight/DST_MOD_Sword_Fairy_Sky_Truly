----------------------------------------------------------------------------------------------------------------------------------
--[[
    
]]--
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_map_jumper = Class(function(self, inst)
    self.inst = inst
    self.current = 0

    self.__net_value = net_float(inst.GUID,"sword_fairy_com_map_jumper","sword_fairy_com_map_jumper")
    inst:ListenForEvent("sword_fairy_com_map_jumper",function(inst, event)
        self.current = self.__net_value:value()
    end)

end,    
nil,
{

})

function sword_fairy_com_map_jumper:SetTestFn(fn)
    if type(fn) == "function" then
        self.test_fn = fn
    end
end
function sword_fairy_com_map_jumper:Test(pt)
    if self:GetCurrent() <= 0 then
        return false
    end
    if self.test_fn then
        return self.test_fn(self.inst,pt)
    end
    return false
end
--------------------------------------------------------------------------------------------
function sword_fairy_com_map_jumper:SetCurrent(num)
    self.current = num
    self.__net_value:set(num)
end
function sword_fairy_com_map_jumper:GetCurrent()
    return self.__net_value:value()
end
--------------------------------------------------------------------------------------------
return sword_fairy_com_map_jumper


