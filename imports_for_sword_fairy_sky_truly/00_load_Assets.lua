
if Assets == nil then
    Assets = {}
end

local temp_assets = {

	------------------------------------------------------------------------------------------------------------------------------------------------------
	--- UI
		Asset("IMAGE", "images/widgets/sword_fairy_book_encyclopedia_ui.tex"),
		Asset("ATLAS", "images/widgets/sword_fairy_book_encyclopedia_ui.xml"),
	------------------------------------------------------------------------------------------------------------------------------------------------------


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

