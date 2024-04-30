--------------------------------------------------------------------------------------------
------ 常用函数放 TUNING 里
--------------------------------------------------------------------------------------------
----- RPC 命名空间
TUNING["sword_fairy_sky_truly.RPC_NAMESPACE"] = "sword_fairy_sky_truly_RPC"


--------------------------------------------------------------------------------------------

TUNING["sword_fairy_sky_truly.fn"] = {}
TUNING["sword_fairy_sky_truly.fn"].GetStringsTable = function(prefab_name)
    -------- 读取文本表
    -------- 如果没有当前语言的问题，调取中文的那个过去
    -------- 节省重复调用运算处理
    if TUNING["sword_fairy_sky_truly.fn"].GetStringsTable_last_prefab_name == prefab_name then
        return TUNING["sword_fairy_sky_truly.fn"].GetStringsTable_last_table or {}
    end


    local LANGUAGE = "ch"
    if type(TUNING["sword_fairy_sky_truly.Language"]) == "function" then
        LANGUAGE = TUNING["sword_fairy_sky_truly.Language"]()
    elseif type(TUNING["sword_fairy_sky_truly.Language"]) == "string" then
        LANGUAGE = TUNING["sword_fairy_sky_truly.Language"]
    end
    local ret_table = prefab_name and TUNING["sword_fairy_sky_truly.Strings"][LANGUAGE] and TUNING["sword_fairy_sky_truly.Strings"][LANGUAGE][tostring(prefab_name)] or nil
    if ret_table == nil and prefab_name ~= nil then
        ret_table = TUNING["sword_fairy_sky_truly.Strings"]["ch"][tostring(prefab_name)]
    end

    ret_table = ret_table or {}
    TUNING["sword_fairy_sky_truly.fn"].GetStringsTable_last_prefab_name = prefab_name
    TUNING["sword_fairy_sky_truly.fn"].GetStringsTable_last_table = ret_table

    return ret_table
end


--------------------------------------------------------------------------------------------
local function GetStringsTable(prefab_name)
    local temp_name = nil
    return TUNING["sword_fairy_sky_truly.fn"].GetStringsTable(temp_name or prefab_name)
end
--------------------------------------------------------------------------------------------