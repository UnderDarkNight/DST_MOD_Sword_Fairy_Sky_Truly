GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TUNING["sword_fairy_sky_truly.Language"] = TUNING["sword_fairy_sky_truly.Language"] or function()
	-- return "en"
	local language = "en"
	pcall(function()
		language = TUNING["sword_fairy_sky_truly.Config"].Language
		if language == "auto" then
			if LOC.GetLanguage() == LANGUAGE.CHINESE_S or LOC.GetLanguage() == LANGUAGE.CHINESE_S_RAIL or LOC.GetLanguage() == LANGUAGE.CHINESE_T then
				language = "ch"
			elseif  LOC.GetLanguage() == LANGUAGE.JAPANESE then
				language = "jp"
			else
				language = "en"
			end
		end
	end)
	return language
end
---------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 调试模式开关
----- 用于新大型版本管理和上线后文件切割。修BUG不用担心新的未完成内容上线造成崩溃。
	TUNING.sword_fairy_sky_truly_DEBUGGING_MODE = TUNING.sword_fairy_sky_truly_DEBUGGING_MODE or GetModConfigData("DEBUGGING_MOD") or false	
		if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
			AddPlayerPostInit(function(player_inst)	---- 玩家进入后再执行。检查。
				if not TheWorld.ismastersim then
					return
				end
				player_inst:DoTaskInTime(2,function()
					TheNet:SystemMessage("剑仙-天真 测试模式 ON")				
				end)
			end)
		end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Assets = {}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modimport("imports_for_sword_fairy_sky_truly/__all_imports_init.lua")	---- 所有 import  文本库（语言库），素材库

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 获取mod 版本
	local mod_info = KnownModIndex:GetModInfo(modname) or {}
	-- local mod_display_name = mod_info.name or ""
	-- local mod_version = mod_info.version
	TUNING["sword_fairy_sky_truly.mod_info"] = mod_info
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


modimport("key_modules_for_sword_fairy_sky_truly/_all_key_modules_init.lua")	---- 载入关键功能模块,在 prefab 加载之前，方便皮肤的API HOOK

PrefabFiles = {  "sword_fairy_sky_truly__all_prefabs"  }		---- 通过总入口 加载所有prefab。



-- if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE == true then
-- 	modimport("test_fn/_Load_All_debug_fn.lua")	---- 载入测试用的模块
-- end
-- dofile(resolvefilepath("test_fn/test.lua"))