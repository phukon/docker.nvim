local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values

local M = {}

M.show_docker_images = function (opts)
  pickers.new(opts, {
    finder = finders.new_table({
      "Yes",
      "No",
      "Maybe",
      "Perhaps",
    }),

    -- The user is exptected to pre-configure a sorter in their config when they first install Telescope.
    -- We are exptected to to just reuse that.
    sorter = config.generic_sorter(opts)
  }):find()
end

M.show_docker_images()

return M
