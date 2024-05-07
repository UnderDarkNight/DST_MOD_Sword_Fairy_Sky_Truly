--------------------------------------------------------------------------------------------------------------------------------------------------
---- 模块总入口，使用 common_postinit 进行嵌入初始化，注意 mastersim 区分
--------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)

    local modules = {
        "prefabs/06_pets/spriter_key_modules/01_magic_point_sys",                             ---- 法力值系统安装

    }
    
    for k, lua_addr in pairs(modules) do
        local temp_fn = require(lua_addr)
        if type(temp_fn) == "function" then
            temp_fn(inst)
        end
    end





    if not TheWorld.ismastersim then
        return
    end

end