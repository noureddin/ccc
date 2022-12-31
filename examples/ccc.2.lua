-- vim: ts=4 sw=4 noet ai cindent syntax=lua
require 'lang'  -- includes math.round()

ccc_week_start = 1  -- Sunday is 0
ccc_show_date = false

local crosses_and_bar = false  -- try setting this to true

-- ccc_force_start_on = 20221031  -- the first week_start day on or before this day
-- -- if omitted, determined a suitable starting date, no earlier than the maximum number (determined by max_in_rows and max_rows belows, by default 12 weeks).
-- -- it's recommended to set this, especially when the number of cells is close to the maximum

ccc_fills = {
	part = 'bottom_left_triangle',
}

ccc_chains = {

	{ label = 'write', color = 'mediumseagreen', streaks = {
		[20221017] = 6,
		[20221023] = 'part',
		[20221024] = 6,
		[20221031] = 7,
		[20221107] = 'part',
		[20221108] = 6,
		[20221114] = 'part',
		[20221115] = 5,
		[20221120] = 'part',
		[20221121] = 7,
		[20221128] = 'part',
		[20221129] = 12,
		[20221211] = 'part',
		[20221212] = 7,
		[20221219] = 'part',
		[20221220] = 6,
		[20221226] = 'part',
		[20221227] = 5,
	}},

	{ label = 'study', color = 'firebrick',
	streaks = {
		[20221017] = 1,
		[20221018] = 'part',
		[20221019] = 'part',
		[20221020] = 1,
		[20221021] = 'part',
		[20221022] = 1,
		[20221024] = 'part',
		[20221025] = 1,
		[20221026] = 'part',
		[20221027] = 'part',
		[20221028] = 1,
		[20221029] = 1,
		[20221031] = 1,
		[20221101] = 'part',
		[20221102] = 1,
		[20221103] = 1,
		[20221104] = 'part',
		[20221105] = 1,
		[20221107] = 1,
		[20221108] = 1,
		[20221109] = 1,
		[20221110] = 'part',
		[20221111] = 'part',
		[20221112] = 'part',
		[20221114] = 1,
		[20221115] = 'part',
		[20221116] = 1,
		[20221117] = 'part',
		[20221118] = 'part',
		[20221119] = 1,
		[20221121] = 1,
		[20221122] = 1,
		[20221123] = 1,
		[20221124] = 1,
		[20221125] = 1,
		[20221126] = 1,
		[20221128] = 1,
		[20221129] = 1,
		[20221130] = 1,
		[20221201] = 1,
		[20221202] = 1,
		[20221203] = 1,
		[20221205] = 'part',
		[20221206] = 'part',
		[20221207] = 'part',
		[20221208] = 'part',
		[20221209] = 'part',
		[20221210] = 'part',
		[20221212] = 'part',
		[20221213] = 'part',
		[20221214] = 'part',
		[20221215] = 'part',
		[20221216] = 'part',
		[20221217] = 'part',
		[20221219] = 1,
		[20221220] = 'part',
		[20221221] = 'part',
		[20221222] = 1,
		[20221223] = 'part',
		[20221224] = 'part',
		[20221226] = 1,
		[20221227] = 1,
		[20221228] = 'part',
		[20221229] = 'part',
		[20221230] = 1,
	}},

}

-- DIMENSIONS --

ccc_side = 25  -- a cell width & height

-- how far the labels from the topleft conky window corner?
ccc_topleft_x = 10
ccc_topleft_y = 10

ccc_gap =  -- the gap between cells in a row, and between rows in a single chain
	math.floor(ccc_side/3)  -- floor() to prevent anti-aliasing from blurring the borders
ccc_label_gap = ccc_gap  -- a gap between the labels and the chains
ccc_week_gap = 2*ccc_gap  -- a gap between groups/chunks of squares in a single row
ccc_chain_gap = math.round(1.5*ccc_gap)  -- a vertical gap between chains, instead of the normal gap

ccc_border_thickness = math.round(ccc_side/25)  -- thickness of normal borders
ccc_today_border_thickness = 2*ccc_border_thickness    -- thickness of today's borders
ccc_full_border_thickness = ccc_today_border_thickness -- thickness of old full cells
ccc_full_border_below = true  -- draws the cell border below the fill, making it thinner i.e. less promiment

ccc_max_in_row = 4  -- max number of weeks (7 squares) in a single row
ccc_max_rows = 3  -- max number of visible rows (before & including today)

-- FONTS --

ccc_label_font = 'DejaVu Sans Mono'
-- ccc_date_font = 'DejaVu Sans Mono'  -- if omitted, takes the value of ccc_label_font

-- COLORS --
-- colors can be named (using CSS or tango names), or using hex notation (like '#F00' for red).
-- also can be provided directly as table of RGB(A) as decimals (each ranging from 0 to 1).

ccc_border_color = {0, 0, 0}  -- opaque black
ccc_label_color = -- if omitted, takes the same value as ccc_border_color
	{0, 0, 0, 0.33}  -- translucent black

-- ccc_background_color -- if omitted, takes no background (ie fully transparent); overridable by a chain's backgroundcolor
-- ccc_empty_background_color -- if omitted, takes the value of ccc_background_color; overridable by a chain's emptybackgroundcolor
-- ccc_date_color  -- if omitted, takes the value of ccc_border_color; overridable by a chain's datecolor
-- ccc_empty_date_color -- if omitted, takes the value of ccc_date_color; overridable by a chain's emptycolor

if crosses_and_bar then
	ccc_show_date = true
	ccc_default_fill = 'cross'
	ccc_border_thickness = 0
	ccc_fills = {
		part = 'bar',
	}
end


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

