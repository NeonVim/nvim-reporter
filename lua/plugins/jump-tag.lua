return {
	setup = function(remap)
		-- HTML
		remap({ "n", "<leader>55", ':lua require("jump-tag").jumpParent()<CR>' })
		remap({ "n", "<leader>5n", ':lua require("jump-tag").jumpNextSibling()<CR>' })
		remap({ "n", "<leader>5p", ':lua require("jump-tag").jumpPrevSibling()<CR>' })
		remap({ "n", "<leader>5c", ':lua require("jump-tag").jumpChild()<CR>' })
	end,
}
