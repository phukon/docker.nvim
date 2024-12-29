local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local utils = require('telescope.previewers.utils')
local config = require('telescope.config').values

local logger = require('plenary.log'):new()
logger.level = 'debug'

local M = {}

M.show_docker_images = function (opts)
  pickers.new(opts, {
    finder = finders.new_async_job({
      command_generator = function ()
        return {"docker", "images", "--format", "json"}
      end,
      -- results = {
      --   {name = "Yes", value = {1, 2, 3, 4}},
      --   {name = "No", value = {1, 2, 3, 4}},
      --   {name = "Maybe", value = {1, 2, 3, 4}},
      --   {name = "Perhaps", value = {1, 2, 3, 4}},
      -- },


      entry_maker = function (entry)
        local parsed = vim.json.decode(entry)
        logger.debug(parsed)
        if parsed then  
          return {
            value = parsed,
            display = parsed.Repository,

            -- ordinal:: search something slightly richer than what you are displaying
            -- this is not displayed but is secretly being searched through
            -- ex: searching 'latest' while the results only show the repository names
            ordinal = parsed.Repository .. ':' .. parsed.Tag,
          }
        end
      end

    }),

    -- The user is exptected to pre-configure a sorter in their config when they first install Telescope.
    -- We are exptected to to just reuse that.
    sorter = config.generic_sorter(opts),

    previewer = previewers.new_buffer_previewer({
      title = "Docker Image Details",
      define_preview = function (self, entry)
        -- grab hold of the buffer that we've been given from the new_buffer_previewer
        -- and write something into it
        vim.api.nvim_buf_set_lines(
          self.state.bufnr,
          0,
          0,
          true,
          vim.tbl_flatten({
            "# " .. entry.value.ID,
            "",
            "```lua",
            vim.split(vim.inspect(entry), "\n"),
            "```"
          })
        )
        utils.highlighter(self.state.bufnr, "markdown")
      end
    }),

  }):find()
end

M.show_docker_images()

return M
