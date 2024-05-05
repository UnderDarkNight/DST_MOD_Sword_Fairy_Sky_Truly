----------------------------------------------------------------------------------------------------------------------------------
--[[

    快速烹饪。挂到玩家身上



]]--
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_fast_cooker = Class(function(self, inst)
    self.inst = inst

    self.fast_times = 0

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
---
    function sword_fairy_com_fast_cooker:DoDelta(num)
        self.fast_times = math.clamp(self.fast_times + num,0,500)
    end
    function sword_fairy_com_fast_cooker:CanFastCook()
        return self.fast_times > 0
    end
------------------------------------------------------------------------------------------------------------------------------
    function sword_fairy_com_fast_cooker:OnSave()
        local data =
        {
            fast_times = self.fast_times
        }
        return next(data) ~= nil and data or nil
    end

    function sword_fairy_com_fast_cooker:OnLoad(data)
        if data.fast_times then
            self.fast_times = data.fast_times
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return sword_fairy_com_fast_cooker







