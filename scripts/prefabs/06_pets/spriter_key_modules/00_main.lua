--------------------------------------------------------------------------------------------------------------------------------------------------
---- 模块总入口，使用 common_postinit 进行嵌入初始化，注意 mastersim 区分
--------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)

    local modules = {
        "prefabs/06_pets/spriter_key_modules/01_magic_point_sys",                             ---- 法力值系统安装
        "prefabs/06_pets/spriter_key_modules/02_food_acceptable",                             ---- 食物接受
        "prefabs/06_pets/spriter_key_modules/04_freshness_setup",                             ---- 食物保鲜组件
        "prefabs/06_pets/spriter_key_modules/05_light",                                       ---- 灯光系统
        "prefabs/06_pets/spriter_key_modules/06_sanityaura",                                  ---- 回San光环
        "prefabs/06_pets/spriter_key_modules/07_workable_setup",                              ---- 右键交互
        "prefabs/06_pets/spriter_key_modules/08_singing_for_plants",                          ---- 唱歌
        "prefabs/06_pets/spriter_key_modules/09_container_event",                             ---- 容器相关的事件
        "prefabs/06_pets/spriter_key_modules/10_sfx",                                         ---- 特效
        "prefabs/06_pets/spriter_key_modules/11_talker",                                      ---- 说话

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