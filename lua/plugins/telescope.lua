local pickers = require("telescope.pickers")
local make_entry = require("telescope.make_entry")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local entry_display = require("telescope.pickers.entry_display")
local utils = require("telescope.utils")
local state = require("telescope.actions.state")
local escape_string = require("functions").escape_string
local f = require("functions")

local builtin = require("telescope.builtin")

local function live_grep()
	builtin.live_grep()
end

local function git_files()
	local ok = pcall(builtin.git_files)
	if not ok then
		require("telescope.builtin").find_files()
	end
end

local function buffers()
	builtin.buffers()
end

local function oldfiles()
	builtin.oldfiles()
end

local function git_commits()
	builtin.git_commits()
end

local function git_branches()
	builtin.git_branches()
end

local function grep_string()
	local word = vim.fn.expand("<cword>")
	builtin.grep_string()
	vim.api.nvim_feedkeys(word, "i", false)
end

local function git_files_string()
	local word = vim.fn.expand("<cword>")
	builtin.git_files()
	vim.api.nvim_feedkeys(word, "i", false)
end

local function git_files_string_visual()
	local text = f.getVisualSelection()
	vim.api.nvim_input("<esc>")
	if text[1] == nil then
		print("No appropriate visual selection found")
	else
		builtin.git_files()
		vim.api.nvim_input(text[1])
	end
end

local function grep_string_visual()
	local text = f.getVisualSelection()
	vim.api.nvim_input("<esc>")
	if text[1] == nil then
		print("No appropriate visual selection found")
	else
		builtin.grep_string()
		vim.api.nvim_input(text[1])
		vim.api.nvim_feedkeys(text, "i", false)
	end
end

local function current_buffer_fuzzy_find()
	require("telescope.builtin").current_buffer_fuzzy_find()
end

function make_entry.gen_from_git_stash(opts)
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 10 },
			opts.show_branch and { width = 15 } or "",
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		return displayer({
			{ entry.value, "TelescopeResultsLineNr" },
			opts.show_branch and { entry.branch_name, "TelescopeResultsIdentifier" } or "",
			entry.commit_info,
		})
	end

	return function(entry)
		if entry == "" then
			return nil
		end

		local splitted = utils.max_split(entry, ": ", 2)
		local stash_idx = splitted[1]
		local _, commit_branch_name = string.match(splitted[2], "^([WIP on|On]+) (.+)")
		local commit_info = splitted[3]

		local real_branch = f.get_branch_name()
		local escaped_commit_branch_name = escape_string(commit_branch_name)

		local search = string.find(real_branch, escaped_commit_branch_name)
		if search == nil then
			return nil
		end

		return {
			value = stash_idx,
			ordinal = commit_info,
			branch_name = commit_branch_name,
			commit_info = commit_info,
			display = make_display,
		}
	end
end

local stash_filter = function()
	local opts = { show_branch = false }
	opts.show_branch = vim.F.if_nil(opts.show_branch, true)
	opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_stash(opts))

	pickers.new(opts, {
		prompt_title = "Git Stash",
		finder = finders.new_oneshot_job({ "git", "--no-pager", "stash", "list" }, opts),
		previewer = previewers.git_stash_diff.new(opts),
		sorter = conf.file_sorter(opts),
		attach_mappings = function()
			actions.select_default:replace(actions.git_apply_stash)
			return true
		end,
	}):find()
end

return {
	setup = function()
		local function SeeCommitChangesInDiffview(prompt_bufnr)
			actions.close(prompt_bufnr)
			local value = state.get_selected_entry(prompt_bufnr).value
			vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
		end

		local function CheckoutAndRestore(prompt_bufnr)
			vim.cmd("Obsession")
			actions.git_checkout(prompt_bufnr)
			f.create_or_source_obsession()
		end

		local function CompareWithCurrentBranchInDiffview(prompt_bufnr)
			actions.close(prompt_bufnr)
			local value = state.get_selected_entry(prompt_bufnr).value
			vim.cmd("DiffviewOpen " .. value)
		end

		local function CopyTextFromPreview(prompt_bufnr)
			local selection = require("telescope.actions.state").get_selected_entry()
			local text = vim.fn.trim(selection["text"])
			vim.fn.setreg('"', text)
			actions.close(prompt_bufnr)
		end

		local function CopyCommitHash(prompt_bufnr)
			local selection = require("telescope.actions.state").get_selected_entry()
			vim.fn.setreg('"', selection.value)
			actions.close(prompt_bufnr)
		end

		local function CopyBranchName(prompt_bufnr)
			local selection = require("telescope.actions.state").get_selected_entry()
			vim.fn.setreg('"', selection.value)
			actions.close(prompt_bufnr)
		end

		local function CreateFile(prompt_bufnr)
			print("WIP")
		end

		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				file_ignore_patterns = { "node_modules", "package%-lock.json" },
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<C-j>"] = actions.cycle_history_next,
						["<C-k>"] = actions.cycle_history_prev,
					},
				},
			},
			pickers = {
				git_files = {
					prompt_prefix = " ",
					mappings = {
						i = {
							["<C-e>"] = CreateFile,
						},
					},
				},
				git_branches = {
					prompt_prefix = " ",
					mappings = {
						i = {
							["<C-y>"] = CopyBranchName,
							["<C-o>"] = CheckoutAndRestore,
							["<Enter>"] = CheckoutAndRestore,
						},
					},
				},
				live_grep = {
					prompt_prefix = " ",
					mappings = {
						i = {
							["<C-y>"] = CopyTextFromPreview,
						},
					},
				},
				oldfiles = {
					prompt_prefix = " ",
				},
				grep_string = {
					prompt_prefix = " ",
				},
				current_buffer_fuzzy_find = {
					previewer = false,
					sorting_strategy = "ascending",
					prompt_prefix = " ",
				},
				buffers = {
					hidden = true,
				},
				git_commits = {
					prompt_prefix = " ",
					mappings = {
						i = {
							["<C-y>"] = CopyCommitHash,
							["<C-o>"] = SeeCommitChangesInDiffview,
							["<C-c>"] = CompareWithCurrentBranchInDiffview,
						},
					},
				},
			},
		})

		telescope.load_extension("fzf")

		require("compat").remap("n", "<C-f>", live_grep, {}, ":lua require('plugins/telescope').live_grep()<CR>")
		require("compat").remap(
			"n",
			"<C-c>",
			current_buffer_fuzzy_find,
			{},
			":lua require('plugins/telescope').current_buffer_fuzzy_find()<CR>"
		)
		require("compat").remap("n", "<C-j>", git_files, {}, ":lua require('plugins/telescope').git_files()<CR>")
		require("compat").remap("n", "<C-g>", buffers, {}, ":lua require('plugins/telescope').buffers()<CR>")
		require("compat").remap("n", "<leader>tr", oldfiles, {}, ":lua require('plugins/telescope').oldfiles()<CR>")
		require("compat").remap(
			"n",
			"<leader>tgc",
			git_commits,
			{},
			":lua require('plugins/telescope').git_commits()<CR>"
		)
		require("compat").remap(
			"n",
			"<leader>tgb",
			git_branches,
			{},
			":lua require('plugins/telescope').git_branches()<CR>"
		)
		require("compat").remap(
			"n",
			"<leader>tF",
			grep_string,
			{},
			":lua require('plugins/telescope').grep_string()<CR>"
		)
		require("compat").remap(
			"n",
			"<leader>tf",
			git_files_string,
			{},
			":lua require('plugins/telescope').git_files_string()<CR>"
		)
		require("compat").remap(
			"v",
			"<leader>tf",
			git_files_string_visual,
			{},
			":lua require('plugins/telescope').git_files_string_visual()<CR>"
		)
		require("compat").remap(
			"v",
			"<leader>tF",
			grep_string_visual,
			{},
			":lua require('plugins/telescope').grep_string_visual()<CR>"
		)

		-- Setup custom stash search which filters by current branch
		require("compat").remap(
			"n",
			"<leader>tgs",
			stash_filter,
			{},
			":lua require('plugins/telescope').stash_filter()<CR>"
		)
	end,
	live_grep = live_grep,
	git_files = git_files,
	buffers = buffers,
	oldfiles = oldfiles,
	git_commits = git_commits,
	git_branches = git_branches,
	grep_string = grep_string,
	current_buffer_fuzzy_find = current_buffer_fuzzy_find,
	git_files_string = git_files_string,
	git_files_string_visual = git_files_string_visual,
	grep_string_visual = grep_string_visual,
	stash_filter = stash_filter,
}
