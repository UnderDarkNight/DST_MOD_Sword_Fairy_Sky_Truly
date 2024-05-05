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

    self._net_data = net_ushortarray(inst.GUID,"sword_fairy_drunkenness.data","sword_fairy_drunkenness.data")
    self.inst:ListenForEvent("sword_fairy_drunkenness.data",function()
        local data = self._net_data:value()
        self.current = data[1]
        self.max = data[2]
        self:ActiveUpdates()
    end)

end)
------------------------------------------------------------------------------------------------------------------------------
---- 
    function sword_fairy_com_drunkenness:SetCurrent(num)
        self.current = num
        local data = {
            [1] = num,
            [2] = self.max,
            [3] = math.random(1000),
        }
        self._net_data:set(data)
    end
    function sword_fairy_com_drunkenness:GetCurrent()
        return self.current
    end
    function sword_fairy_com_drunkenness:SetMax(num)
        self.max = num
        local data = {
            [1] = self.current,
            [2] = num,
            [3] = math.random(1000),
        }
        self._net_data:set(data)
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







