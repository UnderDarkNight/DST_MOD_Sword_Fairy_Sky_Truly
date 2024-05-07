


--------------------------------------------------------------------------------------------------------------------------------------------
---- 避蛇护符
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("sword_fairy_book_empty","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "sword_fairy_book_empty",            --  --  inst.prefab  实体名字
        { Ingredient("goldnugget", 7),Ingredient("papyrus", 7) }, 
        TECH.NONE, --- 科技等级
        {
            -- nounlock=true,
            no_deconstruction=false,
            builder_tag = "sword_fairy_sky_truly",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
            -- placer = "fwd_in_pdt_item_talisman_that_repels_snakes",                       -------- 建筑放置器        
            atlas = "images/inventoryimages/sword_fairy_book_empty.xml",
            image = "sword_fairy_book_empty.tex",
        },
        {"CHARACTER"}
    )
    RemoveRecipeFromFilter("sword_fairy_book_empty","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------