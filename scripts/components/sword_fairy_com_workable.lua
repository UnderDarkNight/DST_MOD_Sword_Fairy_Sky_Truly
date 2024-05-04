----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_workable = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}


end,
nil,
{

})

function sword_fairy_com_workable:SetCanWorlk(flag)
    if not flag then
        self.inst:AddTag("sword_fairy_com_workable_can_not_work")
    else
        self.inst:RemoveTag("sword_fairy_com_workable_can_not_work")
    end
end
function sword_fairy_com_workable:GetCanWorlk()
    return not self.inst:HasTag("sword_fairy_com_workable_can_not_work")
end

function sword_fairy_com_workable:SetActiveFn(fn)
    if type(fn) == "function" then
        self.acive_fn = fn
    end
end

function sword_fairy_com_workable:Active(doer)
    if self.acive_fn then
        return self.acive_fn(self.inst,doer)
    end
    return false
end

function sword_fairy_com_workable:SetOnWorkFn(fn)
    self:SetActiveFn(fn)
end

return sword_fairy_com_workable






