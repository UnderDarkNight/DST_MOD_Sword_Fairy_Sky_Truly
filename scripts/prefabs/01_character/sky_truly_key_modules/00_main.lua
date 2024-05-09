--------------------------------------------------------------------------------------------------------------------------------------------------
---- 模块总入口，使用 common_postinit 进行嵌入初始化，注意 mastersim 区分
--------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)

    if TheWorld.ismastersim then
        if inst.components.sword_fairy_com_data == nil then
            inst:AddComponent("sword_fairy_com_data")
        end
        if inst.components.sword_fairy_com_rpc_event == nil then
            inst:AddComponent("sword_fairy_com_rpc_event")
        end
    end


    local modules = {
        "prefabs/01_character/sky_truly_key_modules/01_hud_badges",                             ---- HUD圈圈添加
        "prefabs/01_character/sky_truly_key_modules/02_magic_point_sys_setup",                  ---- 法力值系统 安装
        "prefabs/01_character/sky_truly_key_modules/03_eater_and_hunger",                       ---- 饥饿值和吃食相关
        "prefabs/01_character/sky_truly_key_modules/04_drunkenness_sys_setup",                  ---- 醉意值系统
        "prefabs/01_character/sky_truly_key_modules/05_sanity",                                 ---- 理智值相关的
        "prefabs/01_character/sky_truly_key_modules/06_power_of_peace",                         ---- 【安康之力】被动
        "prefabs/01_character/sky_truly_key_modules/07_combat_hook",                            ---- 战斗组件HOOK
        "prefabs/01_character/sky_truly_key_modules/08_sword_fx",                               ---- 剑环绕的特效
        "prefabs/01_character/sky_truly_key_modules/09_key_listener",                           ---- 键盘监听器
        "prefabs/01_character/sky_truly_key_modules/10_farm_plants_and_pickable",               ---- 植物采集双倍
        "prefabs/01_character/sky_truly_key_modules/11_playercontroller_hook_for_map_jump",     ---- 地图跳跃hook
        "prefabs/01_character/sky_truly_key_modules/12_map_jumper",                             ---- 地图跳跃组件安装
        "prefabs/01_character/sky_truly_key_modules/13_spriter_setup",                          ---- 安装跟随的精灵
        "prefabs/01_character/sky_truly_key_modules/14_spriter_hat_setup",                      ---- 精灵帽子
        "prefabs/01_character/sky_truly_key_modules/16_workable_player",                        ---- 玩家右键自身
        "prefabs/01_character/sky_truly_key_modules/17_damage_mult",                            ---- 伤害倍增器
        "prefabs/01_character/sky_truly_key_modules/18_combat_hook",                            ---- combat 组件 hook
        "prefabs/01_character/sky_truly_key_modules/19_moisture",                               ---- 潮湿度 组件 hook
        "prefabs/01_character/sky_truly_key_modules/20_temperature",                            ---- 温度 组件 hook
    }
    
    for k, lua_addr in pairs(modules) do
        local temp_fn = require(lua_addr)
        if type(temp_fn) == "function" then
            temp_fn(inst)
        end
    end


    inst:AddTag("sword_fairy_sky_truly")

    -- inst.customidleanim = "moonlightcoda_funny_idle"  -- 闲置站立动画
    -- inst.talksoundoverride = "moonlightcoda_sound/moonlightcoda_sound/talk"
    inst.customidleanim = "idle_wendy"  -- 闲置站立动画
	inst.soundsname = "wendy"




    if not TheWorld.ismastersim then
        return
    end


    -- if TUNING.sword_fairy_sky_truly_DEBUGGING_MODE then
    --     inst:AddComponent("reader")
    -- end

end