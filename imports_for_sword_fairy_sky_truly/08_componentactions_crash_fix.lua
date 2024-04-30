--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 强制修一些 componentactions.lua 里 崩溃。至于为什么崩溃，不知道。
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- local old_UnregisterComponentActions = EntityScript.UnregisterComponentActions
-- EntityScript.UnregisterComponentActions = function(...)
--     -- print("sword_fairy_sky_truly_test UnregisterComponentActions",...)
--     local crash_flg = pcall(old_UnregisterComponentActions,...)
--     if not crash_flg then
--         print("sword_fairy_sky_truly error : UnregisterComponentActions",...)
--     end
-- end

if GLOBAL.EntityScript.UnregisterComponentActions_sword_fairy_sky_truly_old == nil then


    -------------------------------------------------------------------------------------------
    ---- UnregisterComponentActions
        rawset(GLOBAL.EntityScript,"UnregisterComponentActions_sword_fairy_sky_truly_old",rawget(GLOBAL.EntityScript,"UnregisterComponentActions"))
        rawset(GLOBAL.EntityScript, "UnregisterComponentActions", function(self,...)
                -- print("sword_fairy_sky_truly_test UnregisterComponentActions",self,...)
            local crash_flg = pcall(self.UnregisterComponentActions_sword_fairy_sky_truly_old,self,...)
            if not crash_flg then
                print("sword_fairy_sky_truly error : UnregisterComponentActions",self,...)
            end
        end)
    -------------------------------------------------------------------------------------------
    ---- CollectActions
        rawset(GLOBAL.EntityScript,"CollectActions_sword_fairy_sky_truly_old",rawget(GLOBAL.EntityScript,"CollectActions"))
        rawset(GLOBAL.EntityScript, "CollectActions", function(self,...)
                -- print("sword_fairy_sky_truly_test CollectActions",self,...)
            local crash_flg,crash_reason = pcall(self.CollectActions_sword_fairy_sky_truly_old,self,...)
            if not crash_flg then
                print("sword_fairy_sky_truly error : CollectActions",self,...)
                print(crash_reason)
            end
        end)







end