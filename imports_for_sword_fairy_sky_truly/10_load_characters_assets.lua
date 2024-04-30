------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色相关的 素材文件
------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local temp_assets = {


	---------------------------------------------------------------------------
        Asset( "IMAGE", "images/saveslot_portraits/sword_fairy_sky_truly.tex" ), --存档图片
        Asset( "ATLAS", "images/saveslot_portraits/sword_fairy_sky_truly.xml" ),

        Asset( "IMAGE", "bigportraits/sword_fairy_sky_truly.tex" ), --人物大图（方形的那个）
        Asset( "ATLAS", "bigportraits/sword_fairy_sky_truly.xml" ),

        Asset( "IMAGE", "bigportraits/sword_fairy_sky_truly_none.tex" ),  --人物大图（椭圆的那个）
        Asset( "ATLAS", "bigportraits/sword_fairy_sky_truly_none.xml" ),
        
        Asset( "IMAGE", "images/map_icons/sword_fairy_sky_truly.tex" ), --小地图
        Asset( "ATLAS", "images/map_icons/sword_fairy_sky_truly.xml" ),
        
        Asset( "IMAGE", "images/avatars/avatar_sword_fairy_sky_truly.tex" ), --tab键人物列表显示的头像  --- 直接用小地图那张就行了
        Asset( "ATLAS", "images/avatars/avatar_sword_fairy_sky_truly.xml" ),
        
        Asset( "IMAGE", "images/avatars/avatar_ghost_sword_fairy_sky_truly.tex" ),--tab键人物列表显示的头像（死亡）
        Asset( "ATLAS", "images/avatars/avatar_ghost_sword_fairy_sky_truly.xml" ),
        
        Asset( "IMAGE", "images/avatars/self_inspect_sword_fairy_sky_truly.tex" ), --人物检查按钮的图片
        Asset( "ATLAS", "images/avatars/self_inspect_sword_fairy_sky_truly.xml" ),
        
        Asset( "IMAGE", "images/names_sword_fairy_sky_truly.tex" ),  --人物名字
        Asset( "ATLAS", "images/names_sword_fairy_sky_truly.xml" ),
        
        Asset("ANIM", "anim/sword_fairy_sky_truly.zip"),              --- 人物动画文件
        Asset("ANIM", "anim/ghost_sword_fairy_sky_truly_build.zip"),  --- 灵魂状态动画文件

        Asset("ANIM", "anim/sword_fairy_hud_status.zip"),  --- hud 能量条



	---------------------------------------------------------------------------


}
-- for i = 1, 30, 1 do
--     print("fake error ++++++++++++++++++++++++++++++++++++++++")
-- end
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

