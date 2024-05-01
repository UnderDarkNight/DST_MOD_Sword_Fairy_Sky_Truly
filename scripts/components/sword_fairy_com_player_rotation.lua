----------------------------------------------------------------------------------------------------------------------------------
--[[

     玩家角度事件推送

]]--
----------------------------------------------------------------------------------------------------------------------------------
local sword_fairy_com_player_rotation = Class(function(self, inst)
    self.inst = inst

    inst:DoTaskInTime(0,function()
        
        local function push_event(inst)
            inst:PushEvent("sword_fairy_com_player_rotation")
        end

        local old_ForceFacePoint = inst.ForceFacePoint
        inst.ForceFacePoint = function(self,...)
            old_ForceFacePoint(self,...)
            push_event(self)
        end

        local old_FacePoint = inst.FacePoint
        inst.FacePoint = function(self,...)
            old_FacePoint(self,...)
            push_event(self)
        end

        inst:ListenForEvent("locomote",push_event)

    end)


end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
return sword_fairy_com_player_rotation







