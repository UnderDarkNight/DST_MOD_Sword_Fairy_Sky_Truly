-- -- -- 这个文件是给 modmain.lua 调用的总入口
-- -- -- 本lua 和 modmain.lua 平级
-- -- -- 子分类里有各自的入口
-- -- -- 注意文件路径


modimport("key_modules_for_sword_fairy_sky_truly/00_others/__all_others_modules_init.lua") 
-- 难以归类的杂乱东西

modimport("key_modules_for_sword_fairy_sky_truly/01_character/__all_character_modules_init.lua") 
-- 角色模块

modimport("key_modules_for_sword_fairy_sky_truly/02_origin_prefab_upgrade/__all_origin_prefabs_init.lua") 
-- 官方prefab修改

modimport("key_modules_for_sword_fairy_sky_truly/03_origin_components_upgrade/__all_com_init.lua") 
-- 官方components修改

modimport("key_modules_for_sword_fairy_sky_truly/04_actions/__all_actions_init.lua") 
-- 动作组件和sg

modimport("key_modules_for_sword_fairy_sky_truly/05_recipes/__all_recipes_init.lua") 
-- 所有配方

modimport("key_modules_for_sword_fairy_sky_truly/06_widgets/__all_widgets_init.lua") 
-- 界面相关


