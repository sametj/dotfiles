-- Brain: project + fitness commands

local function last_line(output)
	return vim.trim(output):match("[^\n]+$") or ""
end

local function create_brain_project()
	vim.ui.input({ prompt = "Project name: " }, function(input)
		if not input or vim.trim(input) == "" then
			return
		end
		local result = vim.fn.system({ "brain-project", input })
		if vim.v.shell_error ~= 0 then
			vim.notify("Failed:\n" .. result, vim.log.levels.ERROR)
			return
		end
		local dir = last_line(result)
		vim.notify("Project: " .. dir, vim.log.levels.INFO)
		vim.cmd("edit " .. vim.fn.fnameescape(dir .. "/index.md"))
	end)
end

local function open_brain_project()
	vim.ui.input({ prompt = "Project name: " }, function(input)
		if not input or vim.trim(input) == "" then
			return
		end
		local slug = vim.trim(input):lower():gsub(" ", "-")
		local path = vim.fn.expand("~/brain/projects/" .. slug .. "/index.md")
		if vim.fn.filereadable(path) == 1 then
			vim.cmd("edit " .. vim.fn.fnameescape(path))
		else
			vim.notify("Not found. Run: brain-project '" .. input .. "'", vim.log.levels.WARN)
		end
	end)
end

local function create_workout_plan()
	vim.ui.input({ prompt = "Workout name: " }, function(input)
		if not input or vim.trim(input) == "" then
			return
		end
		local result = vim.fn.system({ "brain-workout", input })
		if vim.v.shell_error ~= 0 then
			vim.notify("Failed:\n" .. result, vim.log.levels.ERROR)
			return
		end
		local dir = last_line(result)
		vim.notify("Workout: " .. dir, vim.log.levels.INFO)
		vim.cmd("edit " .. vim.fn.fnameescape(dir .. "/plan.md"))
	end)
end

local function log_workout_session()
	vim.ui.input({ prompt = "Workout slug (e.g. ppl-strength): " }, function(input)
		if not input or vim.trim(input) == "" then
			return
		end
		local result = vim.fn.system({ "brain-session", vim.trim(input) })
		if vim.v.shell_error ~= 0 then
			vim.notify("Failed:\n" .. result, vim.log.levels.ERROR)
			return
		end
		local file = last_line(result)
		vim.cmd("edit " .. vim.fn.fnameescape(file))
		vim.cmd("normal! G")
		vim.notify("Session logged — fill it in!", vim.log.levels.INFO)
	end)
end

vim.api.nvim_create_user_command("BrainProjectNew", create_brain_project, {})
vim.api.nvim_create_user_command("BrainProjectOpen", open_brain_project, {})
vim.api.nvim_create_user_command("WorkoutPlanNew", create_workout_plan, {})
vim.api.nvim_create_user_command("WorkoutSession", log_workout_session, {})

local map = vim.keymap.set
map("n", "<leader>Bp", create_brain_project, { desc = "New brain project" })
map("n", "<leader>Bo", open_brain_project, { desc = "Open brain project" })
map("n", "<leader>Bw", create_workout_plan, { desc = "New workout plan" })
map("n", "<leader>Bs", log_workout_session, { desc = "Log workout session" })
