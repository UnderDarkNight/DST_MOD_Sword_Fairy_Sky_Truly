-- -- -- 这个文件是给 modmain.lua 调用的总入口
-- -- -- 本lua 和 modmain.lua 平级
-- -- -- 子分类里有各自的入口
-- -- -- 注意文件路径


modimport("key_modules_for_sword_fairy_sky_truly/00_others/01_replica_register.lua") 
-- replica 注册器

modimport("key_modules_for_sword_fairy_sky_truly/00_others/02_rpc_event_register.lua") 
-- rpc信道注册

modimport("key_modules_for_sword_fairy_sky_truly/00_others/03_replica_event.lua") 
-- replica 加载event
