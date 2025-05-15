return {
	"ctx.nvim",
	name = "ctx.nvim",
	dependencies = {
		"folke/snacks.nvim", -- Optional dependency for file picker
	},
	cmd = { "Ctx", "CtxShell" },
	dev = { true, dir = "~/projects/ctx.nvim" },
}
