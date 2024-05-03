----------------------------------------------------------------------------------------------------------------------------------
--[[
    
    法力值系统

]]--
----------------------------------------------------------------------------------------------------------------------------------
    local function on_max_update(self,num)
        self.inst:DoTaskInTime(0,function() -- 不知道为什么，得延迟到游戏正常，不然在初始化阶段会丢失数据
            local replica_com = self.inst.replica.sword_fairy_com_magic_point_sys or self.inst.replica._.sword_fairy_com_magic_point_sys
            if replica_com then
                replica_com:SetMax(num)
            end
        end)
    end
    local function on_current_update(self,num)
        self.inst:DoTaskInTime(0,function() -- 不知道为什么，得延迟到游戏正常，不然在初始化阶段会丢失数据
            local replica_com = self.inst.replica.sword_fairy_com_magic_point_sys or self.inst.replica._.sword_fairy_com_magic_point_sys
            if replica_com then
                replica_com:SetCurrent(num)
            end
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_magic_point_sys = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}


    self.current = 0
    self.max = 1


end,
nil,
{
    max = on_max_update,
    current = on_current_update,
})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function sword_fairy_com_magic_point_sys:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function sword_fairy_com_magic_point_sys:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function sword_fairy_com_magic_point_sys:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function sword_fairy_com_magic_point_sys:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- Get
    function sword_fairy_com_magic_point_sys:GetCurrent()
        return self.current
    end
    function sword_fairy_com_magic_point_sys:GetMax()
        return self.max
    end
    function sword_fairy_com_magic_point_sys:GetPercent()
        return self.current / self.max
    end
    function sword_fairy_com_magic_point_sys:SetPercent(num)
        num = math.clamp(num, 0, 1)
        self.current = num * self.max
    end
------------------------------------------------------------------------------------------------------------------------------
----- 法力值（包括上限） DoDelta
    function sword_fairy_com_magic_point_sys:DoDelta(num)
        local old_num = self.current
        local new_num = old_num + num
        self.current = math.clamp(new_num, 0, self.max)
        self.inst:PushEvent("magic_point_dodelta",{
            old = old_num,
            current = self.current,
            max = self.max
        })
    end
    function sword_fairy_com_magic_point_sys:DoDeltaPercent(num)
        -- num = math.clamp(num, 0, 1)
        num = num * self.max
        self:DoDelta(num)
    end
    function sword_fairy_com_magic_point_sys:DoDeltaMax(num)
        local old_max_num = self.max
        local new_max_num = old_max_num + num
        if new_max_num < 1 then
            new_max_num = 1
        end
        self.max = new_max_num
        self.inst:PushEvent("magic_point_dodelta_max",{
            old = old_max_num,
            new = self.max
        })

        self.current = math.clamp(self.current, 0, self.max)
        self.inst:PushEvent("magic_point_dodelta",{
            old = self.current,
            current = self.current,
            max = self.max
        })
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function sword_fairy_com_magic_point_sys:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            -- DataTable = self.DataTable
            current = self.current,
            max = self.max
        }
        return next(data) ~= nil and data or nil
    end

    function sword_fairy_com_magic_point_sys:OnLoad(data)
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
return sword_fairy_com_magic_point_sys







