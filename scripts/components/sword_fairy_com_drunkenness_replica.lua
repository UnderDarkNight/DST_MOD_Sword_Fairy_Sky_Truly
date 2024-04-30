----------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_drunkenness = Class(function(self, inst)
    self.inst = inst


    self.update_fn = {}

    self.current = 0
    self.max = 1

    self._net_current_float = net_float(inst.GUID,"sword_fairy_drunkenness.current","sword_fairy_drunkenness.current")
    self._net_max_float = net_float(inst.GUID,"sword_fairy_drunkenness.max","sword_fairy_drunkenness.max")

    if not TheNet:IsDedicated() then    --- 只在客户端执行
        self.inst:ListenForEvent("sword_fairy_drunkenness.current",function()
            self:ActiveUpdates()
        end)
        self.inst:ListenForEvent("sword_fairy_drunkenness.max",function()
            self:ActiveUpdates()
        end)
    end

end)
------------------------------------------------------------------------------------------------------------------------------
---- 
    function sword_fairy_com_drunkenness:SetCurrent(num)
        self.current = num
        self._net_current_float:set(num)
    end
    function sword_fairy_com_drunkenness:GetCurrent()
        return self.current
    end
    function sword_fairy_com_drunkenness:SetMax(num)
        self.max = num
        self._net_max_float:set(num)
    end
    function sword_fairy_com_drunkenness:GetMax()
        return self.max
    end
    function sword_fairy_com_drunkenness:GetPercent()
        return self.current / self.max
    end
------------------------------------------------------------------------------------------------------------------------------
---- 更新函数,只在客户端执行
    function sword_fairy_com_drunkenness:AddUpdateFn(fn)
        if type(fn) == "function" then
            table.insert(self.update_fn, fn)
        end
    end
    function sword_fairy_com_drunkenness:ActiveUpdates()
        for k, v in pairs(self.update_fn) do
            v(self.inst,self.current,self.max,self:GetPercent())
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return sword_fairy_com_drunkenness







