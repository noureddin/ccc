-- vim: ts=4 sw=4 noet ai cindent syntax=lua

-- no chains, just a preview of the ("officially supported") fill patterns.

ccc_preview_fills = true
ccc_preview_symmetric_gap = true
ccc_preview_background = 'beige'
-- ccc_preview_cell_color = 'black'
ccc_preview_label_color = 'black'
ccc_preview_cell_border_color = 'black'

ccc_preview_cell_backgroundcolor = 'white'
ccc_preview_cell_border_thickness = 1

-- ccc_preview_cell_backgroundcolor = 'transparent'
-- ccc_preview_cell_border_thickness = 0


-- CONKY --

conky.config = {
    lua_load = 'main.lua',
    lua_draw_hook_post = 'draw_chains',
    alignment = 'top_left',
    gap_x = 20,
    gap_y = 20,
    minimum_height = 1000,
    minimum_width = 1980,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'override',
    own_window_argb_visual = true,
    own_window_argb_value = 0,
    double_buffer = true,
    update_interval = 180,  -- 3mins
}

conky.text = ''

