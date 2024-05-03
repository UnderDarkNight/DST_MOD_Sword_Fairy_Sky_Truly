----------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_magic_point_sys = Class(function(self, inst)
    self.inst = inst


    self.update_fn = {}

    self.current = 0
    self.max = 1

    self._net_current_float = net_float(inst.GUID,"sword_fairy_mp.current","sword_fairy_mp.current")
    self._net_max_float = net_float(inst.GUID,"sword_fairy_mp.max","sword_fairy_mp.max")

    if not TheNet:IsDedicated() then
        self.inst:ListenForEvent("sword_fairy_mp.current",function()
            self.current = self._net_current_float:value()
            self:ActiveUpdates()
        end)
        self.inst:ListenForEvent("sword_fairy_mp.max",function()
            self.max = self._net_max_float:value()
            self:ActiveUpdates()
        end)
    end

end)
------------------------------------------------------------------------------------------------------------------------------
---- 
    function sword_fairy_com_magic_point_sys:SetCurrent(num)
        self.current = num
        self._net_current_float:set(num)
    end
    function sword_fairy_com_magic_point_sys:GetCurrent()
        return self.current
    end
    function sword_fairy_com_magic_point_sys:SetMax(num)
        self.max = num
        self._net_max_float:set(num)
    end
    function sword_fairy_com_magic_point_sys:GetMax()
        return self.max
    end
    function sword_fairy_com_magic_point_sys:GetPercent()
        return self.current / self.max
    end
------------------------------------------------------------------------------------------------------------------------------
---- 更新函数,只在客户端执行
    function sword_fairy_com_magic_point_sys:AddUpdateFn(fn)
        if type(fn) == "function" then
            table.insert(self.update_fn, fn)
        end
    end
    function sword_fairy_com_magic_point_sys:ActiveUpdates()
        for k, v in pairs(self.update_fn) do
            v(self.inst,self.current,self.max,self:GetPercent())
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return sword_fairy_com_magic_point_sys







