local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local config = require('telescope.config').values

local M = {}

M.show_docker_images = function (opts)
  pickers.new(opts, {
    finder = finders.new_table({
      results = {
        {name = "Yes", value = {1, 2, 3, 4}},
        {name = "No", value = {1, 2, 3, 4}},
        {name = "Maybe", value = {1, 2, 3, 4}},
        {name = "Perhaps", value = {1, 2, 3, 4}},
      },


      entry_maker = function (entry)
        return {
          display = entry.name,
          ordinal = entry.name,
        }
      end

    }),

    -- The user is exptected to pre-configure a sorter in their config when they first install Telescope.
    -- We are exptected to to just reuse that.
    sorter = config.generic_sorter(opts),

    previewer = previewers.new_buffer_previewer({
      title = "Docker Image Details",
      define_preview = function (self, entry)
        -- grab hold of the buffer that we've been give from the new_buffer_previewer
        -- and write something into it
        vim.api.nvim_buf_set_lines(
          self.state.bufnr,
          0,
          0,
          true,
          vim.tbl_flatten({"Yo", "wassup?!", vim.split(vim.inspect(entry), "\n")})
        )
      end
    }),

  }):find()
end

M.show_docker_images()

return M
