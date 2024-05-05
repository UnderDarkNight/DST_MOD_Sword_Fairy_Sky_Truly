----------------------------------------------------------------------------------------------------------------------------------
--[[
    
]]--
----------------------------------------------------------------------------------------------------------------------------------
local function on_current(self,num)
    self.inst:DoTaskInTime(0,function()        
        local replica_com = self.inst.replica.sword_fairy_com_map_jumper or self.inst.replica._.sword_fairy_com_map_jumper
        if replica_com then
            replica_com:SetCurrent(num)
        end
    end)
end
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_map_jumper = Class(function(self, inst)
    self.inst = inst

    self.current = 0
end,
nil,
{
    current = on_current,
})

function sword_fairy_com_map_jumper:SetSpellFn(fn)
    if type(fn) == "function" then
        self.spellFn = fn
    end
end
function sword_fairy_com_map_jumper:CastSpell(pt)
    if self.spellFn then
        return self.spellFn(self.inst,pt)
    end
end

function sword_fairy_com_map_jumper:SetPreSpellFn(fn)
    if type(fn) == "function" then
        self.preSpellFn = fn
    end
end
function sword_fairy_com_map_jumper:CastPreSpell(pt)
    if self.preSpellFn then
        return self.preSpellFn(self.inst,pt)
    end
end

function sword_fairy_com_map_jumper:DoDelta(num)    
    self.current = math.clamp(self.current + num,0,500)
end

function sword_fairy_com_map_jumper:OnSave()
    local data =
    {
        current = self.current
    }
    return next(data) ~= nil and data or nil
end

function sword_fairy_com_map_jumper:OnLoad(data)
    if data.current then
        self.current = data.current
    end
end
return sword_fairy_com_map_jumper


