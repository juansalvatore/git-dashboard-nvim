M = {}

M.setup = function(config)
	print("git dashboard nvim setup")
	P(config)
end

M.config = {
	theme = "github",
	preview = {
		enabled = true,
	},
}

return M
