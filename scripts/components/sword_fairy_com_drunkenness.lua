----------------------------------------------------------------------------------------------------------------------------------
--[[
    
    法力值系统

]]--
----------------------------------------------------------------------------------------------------------------------------------
    local function on_max_update(self,num)
        local replica_com = self.inst.replica.sword_fairy_com_drunkenness or self.inst.replica._.sword_fairy_com_drunkenness
        if replica_com then
            replica_com:SetMax(num)
        end
    end
    local function on_current_update(self,num)
        local replica_com = self.inst.replica.sword_fairy_com_drunkenness or self.inst.replica._.sword_fairy_com_drunkenness
        if replica_com then
            replica_com:SetCurrent(num)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_drunkenness = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}


    self.current = 0
    self.max = 7

    self.intoxicated_value = TUNING["sword_fairy_sky_truly.Config"].intoxicated or 14

end,
nil,
{
    max = on_max_update,
    current = on_current_update,
})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function sword_fairy_com_drunkenness:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function sword_fairy_com_drunkenness:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function sword_fairy_com_drunkenness:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function sword_fairy_com_drunkenness:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- Get
    function sword_fairy_com_drunkenness:GetCurrent()
        return self.current
    end
    function sword_fairy_com_drunkenness:GetMax()
        return self.max
    end
    function sword_fairy_com_drunkenness:GetPercent()
        return self.current / self.max
    end
    function sword_fairy_com_drunkenness:IsIntoxicated()
        return self.current >= self.intoxicated_value
    end
    function sword_fairy_com_drunkenness:GetIntoxicatedValue()
        return self.intoxicated_value
    end
------------------------------------------------------------------------------------------------------------------------------
----- 法力值（包括上限） DoDelta
    function sword_fairy_com_drunkenness:DoDelta(num)
        local old_num = self.current
        local new_num = old_num + num
        self.current = math.clamp(new_num, 0, self.max)
        self.inst:PushEvent("drunkenness_dodelta",{
            old = old_num,
            current = self.current,
            max = self.max
        })
    end
    function sword_fairy_com_drunkenness:DoDeltaMax(num)
        local old_max_num = self.max
        local new_max_num = old_max_num + num
        if new_max_num < 1 then
            new_max_num = 1
        end
        self.max = new_max_num
        self.inst:PushEvent("drunkenness_dodelta_max",{
            old = old_max_num,
            new = self.max
        })

        self.current = math.clamp(self.current, 0, self.max)
        self.inst:PushEvent("drunkenness_dodelta",{
            old = self.current,
            current = self.current,
            max = self.max
        })
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function sword_fairy_com_drunkenness:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            -- DataTable = self.DataTable
            current = self.current,
            max = self.max
        }
        return next(data) ~= nil and data or nil
    end

    function sword_fairy_com_drunkenness:OnLoad(data)
        -- if data.DataTable then
        --     self.DataTable = data.DataTable
        -- end
        if data.current then
            self.current = data.current
        end
        if data.max then
            self.max = data.max
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return sword_fairy_com_drunkenness







