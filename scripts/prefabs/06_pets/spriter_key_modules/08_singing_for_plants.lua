--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    local RANGE = 8
    local musthavetags = {"farm_plant"}
    local canthavetags = nil
    local musthaveoneoftags = nil


    local function sing_for_farm_plants()
        local sing_flag = false
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, RANGE, musthavetags, canthavetags, musthaveoneoftags)
        for k, temp_target in pairs(ents) do
            if temp_target.components.farmplanttendable ~= nil then
                local last_tendable = temp_target.components.farmplanttendable.tendable
                temp_target.components.farmplanttendable:TendTo(inst:GetLinkedPlayer())
                if last_tendable ~= temp_target.components.farmplanttendable.tendable then
                    sing_flag = true
                end
            end
        end
        if sing_flag then
            inst:Say_With_Index("say.sing")
        end
    end


    inst:DoPeriodicTask(5,function()
        if inst:HasTag("spriter_hat_active") then
            return
        end
        sing_for_farm_plants()
    end)

end