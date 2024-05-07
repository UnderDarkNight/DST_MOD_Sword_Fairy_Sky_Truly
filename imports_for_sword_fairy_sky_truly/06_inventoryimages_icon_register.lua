---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 统一注册 【 images\inventoryimages 】 里的所有图标
--- 每个 xml 里面 只有一个 tex

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local files_name = {

	---------------------------------------------------------------------------------------
	-- 02_items
		"sword_fairy_weapon_flying_sword",					--- 飞剑
		"sword_fairy_book_encyclopedia",					--- 《百科全书》
		"sword_fairy_book_empty",							--- 《无字天书》

	---------------------------------------------------------------------------------------
	-- 04_foods
		"sword_fairy_food_white_spirit",						--- 白酒
		"sword_fairy_food_fruit_liqor",						    --- 果酒
		"sword_fairy_food_tincture",						    --- 药酒
		"sword_fairy_food_sacred_wine",						    --- 仙酒
	---------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/".. name ..".xml" ))
	RegisterInventoryItemAtlas("images/inventoryimages/".. name ..".xml", name .. ".tex")
end


