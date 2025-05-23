require("git"):setup()

require("zoxide"):setup({
	update_db = true, -- update zoxide on cd
})

require("custom-shell"):setup({
	history_path = "default",
	save_history = true,
})

-- require("relative-motions"):setup({
-- 	show_numbers = "relative",
-- 	show_motion = true,
-- 	enter_mode = "first",
-- })

require("bookmarks"):setup({
	last_directory = { enable = true, persist = false, mode = "dir" },
	persist = "vim",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	notify = {
		enable = true,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

if os.getenv("NVIM") then
	require("toggle-pane"):entry("min-preview")
end
