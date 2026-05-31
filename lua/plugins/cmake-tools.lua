local cmake = require("cmake-tools")

local overseer_opts = {
  	new_task_opts = {
  		strategy = "jobstart",
  	},
  	on_new_task = function()
  		require("overseer").open({ enter = false, direction = "bottom" })
  	end,
}

cmake.setup({
  	cmake_command = "cmake",
  	ctest_command = "ctest",
  	cmake_use_preset = true,
  	cmake_regenerate_on_save = true,
	cmake_build_directory = function()
    if require("cmake-tools.osys").iswin32 then
		return "build\\${variant:buildType}"
    end
		return "build/${variant:buildType}"
	end,
  	cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },

  	cmake_executor = {
  		name = "overseer",
  		opts = overseer_opts,
  	},

  	cmake_runner = {
  		name = "overseer",
  		opts = overseer_opts,
  	},
})
