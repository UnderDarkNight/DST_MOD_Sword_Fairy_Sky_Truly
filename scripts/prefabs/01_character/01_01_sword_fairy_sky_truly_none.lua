local assets =
{
	Asset( "ANIM", "anim/sword_fairy_sky_truly.zip" ),
	Asset( "ANIM", "anim/ghost_sword_fairy_sky_truly_build.zip" ),
}
local skin_fns = {

	-----------------------------------------------------
		CreatePrefabSkin("sword_fairy_sky_truly_none",{
			base_prefab = "sword_fairy_sky_truly",			---- 角色prefab
			skins = {
					normal_skin = "sword_fairy_sky_truly",					--- 正常外观
					ghost_skin = "ghost_sword_fairy_sky_truly_build",			--- 幽灵外观
			}, 								
			assets = assets,
			skin_tags = {"BASE" ,"sword_fairy_sky_truly", "CHARACTER"},		--- 皮肤对应的tag
			
			build_name_override = "sword_fairy_sky_truly",
			rarity = "Character",
		}),
	-----------------------------------------------------
	-----------------------------------------------------
		-- CreatePrefabSkin("sword_fairy_sky_truly_skin_flame",{
		-- 	base_prefab = "sword_fairy_sky_truly",			---- 角色prefab
		-- 	skins = {
		-- 			normal_skin = "sword_fairy_sky_truly_skin_flame", 		--- 正常外观
		-- 			ghost_skin = "ghost_sword_fairy_sky_truly_build",			--- 幽灵外观
		-- 	}, 								
		-- 	assets = assets,
		-- 	skin_tags = {"BASE" ,"sword_fairy_sky_truly_CARL", "CHARACTER"},		--- 皮肤对应的tag
			
		-- 	build_name_override = "sword_fairy_sky_truly",
		-- 	rarity = "Character",
		-- }),
	-----------------------------------------------------

}

return unpack(skin_fns)