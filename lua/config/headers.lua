local M = {}

function M.find_alternate()
    local current_file = vim.fn.expand('%:p')
    local file_name = vim.fn.expand('%:t:r')
    local is_header = vim.fn.expand('%:e') == 'h'
    local root_dir = vim.fn.getcwd()
    
    local alternate_patterns = {}
    local pattern_msgs = {}
    
    if is_header then
        alternate_patterns = {
            string.format('%s/**/%s.cpp', root_dir, file_name),
            string.format('%s/**/Private/**/%s.cpp', root_dir, file_name)
        }
        pattern_msgs = {
            string.format("Anywhere: %s.cpp", file_name),
            string.format("Private folders: %s.cpp", file_name)
        }
    else
        alternate_patterns = {
            string.format('%s/**/%s.h', root_dir, file_name),
            string.format('%s/**/Public/**/%s.h', root_dir, file_name)
        }
        pattern_msgs = {
            string.format("Anywhere: %s.h", file_name),
            string.format("Public folders: %s.h", file_name)
        }
    end

    local tried_paths = {}
    for i, pattern in ipairs(alternate_patterns) do
        local files = vim.split(vim.fn.glob(pattern, 1), '\n')
        for _, found in ipairs(files) do
            if found ~= '' and found ~= current_file then
                vim.cmd('edit '..found)
                return
            elseif found ~= '' then
                table.insert(tried_paths, found)
            end
        end
    end

    if #tried_paths > 0 then
        vim.notify('Possible matches excluded (current file):\n' .. table.concat(tried_paths, '\n'), vim.log.levels.WARN)
    else
        vim.notify('Could not find alternate file. Tried:\n' .. table.concat(pattern_msgs, '\n'), vim.log.levels.WARN)
    end
end

return M
