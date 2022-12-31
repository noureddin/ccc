-- vim: ts=4 sw=4 noet ai cindent syntax=lua

ccc_week_start = 1  -- Sunday is 0
ccc_show_date = true  -- the default; set to false to hide date
ccc_date_day_only = true  -- otherwise shows day & month on each cell

-- ccc_force_start_on = 20221031  -- the first week_start day on or before this day
-- -- if omitted, determined a suitable starting date, no earlier than the maximum number (determined by max_in_rows and max_rows belows, by default 12 weeks).
-- -- it's recommended to set this, especially when the number of cells is close to the maximum

ccc_chains = {

	{ label = 'ok', color = 'orchid', streaks = {  -- a simple yes/no task
		[20221105] = 15,
		[20221121] = 22,
		[20221214] = 18,
	}},

}

ccc_side = 25  -- a cell width & height

-- how far the labels from the topleft conky window corner?
ccc_topleft_x = 10
ccc_topleft_y = 10

ccc_max_in_row = 4  -- max number of weeks (7 squares) in a single row
ccc_max_rows = 3  -- max number of visible rows (before & including today)

ccc_label_font = 'DejaVu Sans Mono'

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

