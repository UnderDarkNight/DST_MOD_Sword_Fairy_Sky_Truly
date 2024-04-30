----------------------------------------------------------------------------------------------------------------------------------
--[[

    食物拒绝器

]]--
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_food_refuser = Class(function(self, inst)
    self.inst = inst

    self.default_refuse_reason = "XXXXXXX"
    self.refuse_reason_by_prefab = {}
end)
------------------------------------------------------------------------------------------------------------------------------
--- 拒绝原因
    function sword_fairy_com_food_refuser:GetRefuseReason(item)
        return self.refuse_reason_by_prefab[item.prefab] or (self._refuse_reason_fn and self._refuse_reason_fn(item) ) or self.default_refuse_reason 
    end
    function sword_fairy_com_food_refuser:SetFoodRefuseReason(food_prefab, reason)
        self.refuse_reason_by_prefab[food_prefab] = reason
    end
    function sword_fairy_com_food_refuser:SetDefaultRefuseReason(reason)
        self.default_refuse_reason = reason
    end
    function sword_fairy_com_food_refuser:SetRefuseReasonFn(fn)
        self._refuse_reason_fn = fn
    end
------------------------------------------------------------------------------------------------------------------------------
return sword_fairy_com_food_refuser







