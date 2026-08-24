-- gh-gfm-preview (unlike GitHub itself) renders fenced ```math blocks as a
-- literal <pre><code> block instead of handing them to its math renderer, so
-- backslashes/entities come out HTML-escaped and MathJax never sees them.
-- Wrapping the same content in a raw <div> instead makes Goldmark pass it
-- through byte-for-byte, which MathJax then typesets like GitHub does.
-- We stage a sibling copy with that rewrite applied and preview that instead,
-- keeping it in sync on every save; files with no ```math blocks are
-- previewed unchanged.
local function stage_math_fences(filepath)
  local content = table.concat(vim.fn.readfile(filepath), "\n")
  local staged, count = content:gsub("```math\n(.-)\n```", "<div>\n%1\n</div>")
  if count == 0 then
    return filepath
  end
  local staged_path = vim.fn.fnamemodify(filepath, ":h")
    .. "/."
    .. vim.fn.fnamemodify(filepath, ":t")
    .. ".gfm-preview.md"
  vim.fn.writefile(vim.split(staged, "\n", { plain = true }), staged_path)
  return staged_path
end

return {
  "babarot/markdown-preview.nvim",
  ft = "markdown",
  opts = {
    gh_cmd = "gfm-preview",
  },
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
    { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown Preview Stop" },
    { "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
  },
  config = function(_, opts)
    local mdp = require("markdown-preview")
    mdp.setup(opts)

    local process = nil
    local source_path = nil
    local staged_path = nil
    local augroup = vim.api.nvim_create_augroup("MarkdownPreviewGfmStage", { clear = true })

    local function cleanup_staged()
      if staged_path and staged_path ~= source_path then
        vim.fn.delete(staged_path)
      end
      source_path, staged_path = nil, nil
      vim.api.nvim_clear_autocmds({ group = augroup })
    end

    mdp.start = function(start_opts)
      start_opts = start_opts or {}

      if process then
        vim.notify("Markdown preview is already running", vim.log.levels.WARN)
        return
      end
      if vim.bo.filetype ~= "markdown" then
        vim.notify("Current buffer is not a markdown file", vim.log.levels.ERROR)
        return
      end

      local filepath = vim.fn.expand("%:p")
      if filepath == "" or vim.fn.filereadable(filepath) == 0 then
        vim.notify("Please save the file before previewing", vim.log.levels.WARN)
        return
      end

      source_path = filepath
      staged_path = stage_math_fences(filepath)

      if staged_path ~= filepath then
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = augroup,
          buffer = vim.api.nvim_get_current_buf(),
          desc = "Refresh staged GFM math preview file",
          callback = function()
            stage_math_fences(filepath)
          end,
        })
      end

      local cmd = { "gh", mdp.config.gh_cmd, staged_path }
      if start_opts.dark_mode then
        table.insert(cmd, "--dark-mode")
      elseif start_opts.light_mode then
        table.insert(cmd, "--light-mode")
      end
      if start_opts.disable_auto_open then
        table.insert(cmd, "--disable-auto-open")
      end
      if start_opts.port then
        table.insert(cmd, "--port")
        table.insert(cmd, tostring(start_opts.port))
      end

      process = vim.system(cmd, { text = true, detach = true }, function(obj)
        process = nil
        cleanup_staged()
        vim.schedule(function()
          if obj.code ~= 0 then
            vim.notify(
              string.format("Markdown preview exited with code %d\n%s", obj.code, obj.stderr or "Unknown error"),
              vim.log.levels.ERROR
            )
          else
            vim.notify("Markdown preview stopped", vim.log.levels.INFO)
          end
        end)
      end)

      vim.notify("Markdown preview started at http://localhost:" .. (start_opts.port or 3333), vim.log.levels.INFO)
    end

    mdp.stop = function()
      if not process then
        vim.notify("No markdown preview is running", vim.log.levels.WARN)
        return
      end
      process:kill(15)
      process = nil
      cleanup_staged()
    end

    mdp.toggle = function(toggle_opts)
      if process then
        mdp.stop()
      else
        mdp.start(toggle_opts)
      end
    end

    mdp.is_running = function()
      return process ~= nil
    end
  end,
}
