------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    烹饪锅组件

    添加个事件，实现烹饪锅瞬间完成
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddComponentPostInit("stewer", function(stewer_com)
    if not TheWorld.ismastersim then
        return
    end

    stewer_com.inst:ListenForEvent("sword_fairy_fast_cook_force_finish",function(inst)
        if stewer_com:IsCooking() and not stewer_com:IsDone() then
            if type(stewer_com.targettime) == "number" then 
                -- dostew(inst,stewer_com)
                -- stewer_com:LongUpdate(10000)    ---- 找到个更快捷的方法

                    --- self.targettime - dt - GetTime() = 0
                    local dt = stewer_com.targettime - GetTime()
                    if dt > 0 then
                        stewer_com:LongUpdate( dt )    ---- 找到个更快捷的方法
                    end
            end
        end
    end)

    ----------------------------------------------------------------------------------
    ---- 推送事件
        local old_StartCooking_fn = stewer_com.StartCooking

        stewer_com.StartCooking = function(self,doer,...)
            old_StartCooking_fn(self,doer,...)
            self.inst:DoTaskInTime(0.5,function()
                if self:IsCooking() and not self:IsDone() then
                    -- doer:PushEvent("fwd_in_pdt_event.stewer.cooking_started",self.inst)
                    if doer and doer.components.sword_fairy_com_fast_cooker and doer.components.sword_fairy_com_fast_cooker:CanFastCook() then
                        self.inst:PushEvent("sword_fairy_fast_cook_force_finish")
                        doer.components.sword_fairy_com_fast_cooker:DoDelta(-1)
                    end
                end
            end)
        end

    ----------------------------------------------------------------------------------




end)