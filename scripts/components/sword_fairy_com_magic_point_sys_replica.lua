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

    self._net_data = net_ushortarray(inst.GUID,"sword_fairy_mp.data","sword_fairy_mp.data")
    self.inst:ListenForEvent("sword_fairy_mp.data",function()
        local temp_data = self._net_data:value()
        self.current = temp_data[1]
        self.max = temp_data[2]
        self:ActiveUpdates()
        self.inst:PushEvent("sword_fairy_mp_replica_data_refresh")
    end)
    

end)
------------------------------------------------------------------------------------------------------------------------------
---- 
    function sword_fairy_com_magic_point_sys:SetCurrent(num)
        self.current = num
        local data = {
            [1] = num,
            [2] = self.max,
            [3] = math.random(1000),
        }
        self._net_data:set(data)
    end
    function sword_fairy_com_magic_point_sys:GetCurrent()
        return self.current
    end
    function sword_fairy_com_magic_point_sys:SetMax(num)
        self.max = num
        local data = {
            [1] = self.current,
            [2] = num,
            [3] = math.random(1000),
        }
        self._net_data:set(data)
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







