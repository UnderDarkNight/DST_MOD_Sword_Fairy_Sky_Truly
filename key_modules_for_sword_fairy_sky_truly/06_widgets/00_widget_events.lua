------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本文件主要是做一些辅助事件注册，方便一些界面的HOOK修改

---- 给  ThePlayer.HUD 里挂载一些 event ，触发特殊界面hookk

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------- 容器界面的开关,往 inst 发送事件和  widget。方便修改
AddClassPostConstruct("screens/playerhud",function(self)

    local old_OpenContainer_fn = self.OpenContainer
    self.OpenContainer = function(self,container_inst,side,...)
        old_OpenContainer_fn(self,container_inst,side,...)  
        if container_inst and container_inst.PushEvent and self.controls and self.controls.containers and self.controls.containers[container_inst] then
            container_inst:PushEvent("sword_fairy_event.container_widget_open",self.controls.containers[container_inst])
        end
    end


    local old_CloseContainer_fn = self.CloseContainer
    self.CloseContainer = function(self,container_inst,side,...)
        old_CloseContainer_fn(self,container_inst,side,...)
        if container_inst and container_inst.PushEvent then
            container_inst:PushEvent("sword_fairy_event.container_widget_close")
        end
    end

end)