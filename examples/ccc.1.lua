-- vim: ts=4 sw=4 noet ai cindent syntax=lua
require 'lang'  -- includes math.round()

ccc_week_start = 1  -- Sunday is 0
ccc_show_date = true  -- the default; set to false to hide date
ccc_date_day_only = true  -- otherwise shows day & month on each cell

-- ccc_force_start_on = 20221031  -- the first week_start day on or before this day
-- -- if omitted, determined a suitable starting date, no earlier than the maximum number (determined by max_in_rows and max_rows belows, by default 12 weeks).
-- -- it's recommended to set this, especially when the number of cells is close to the maximum

ccc_chains = {

	{ label = 'ok', color = 'orchid', streaks = {  -- a simple yes/no task
		[20221201] = 11,
		[20221213] = 18,
	}},

	{ label = 'color', color = 'mediumseagreen',
		partial_background_color = 'hotpink',  -- the backgroud color behind a fill
		empty_background_color = 'white',  -- the background color for empty (missed) days
		full_date_color = 'yellow',  -- the font color for the text on complete days
		partial_date_color = 'cyan',  -- the font color for the text on partial (pattern-filled) days
		empty_date_color = 'blue',  -- the font color for the text on empty days
		border_color = 'cyan',
	streaks = {  -- a task with fancy colors
		[20221201] = 11,
		[20221213] = 18,
		[20221231] = 'bottom_left_triangle',
	}},

	{ label = "X's", color = 'red',
		default_fill = 'cross',
		empty_border_thickness = 0,
		partial_border_thickness = 0,
		full_border_thickness = 0,
	streaks = {  -- a task with red X's
		[20221201] = 11,
		[20221213] = 18,
	}},

    { label = 'write', color = 'slateblue', background_color = '#bbb', date_color = 'white', fills = {
        a = 'bottom_left_triangle',  -- 100--250
        b = 'reverse_checkered4',    -- 250--500
        c = 'right_most',            -- 500--1,000
                                     -- more is 1
    }, streaks = {
        [20221201] = 'a', -- 182
        [20221202] = 'b', -- 252
        [20221203] = 'b', -- 268
        [20221204] = 'a', -- 198
        [20221205] = 'c', -- 512
        [20221206] = 1,   -- 1,008  (notice: no quotes for numbers!)
        [20221207] = 'c', -- 721
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

ccc_max_in_row = 4  -- max number of weeks (7 squares) in a single row
ccc_max_rows = 3  -- max number of visible rows (before & including today)

-- FONTS --

ccc_label_font = 'DejaVu Sans Mono'
-- ccc_date_font = 'DejaVu Sans Mono'  -- if omitted, takes the value of ccc_label_font

-- COLORS --
-- colors can be named (using CSS or tango names), or using hex notation (like '#F00' for red).
-- can also be provided directly as table of RGB(A) as decimals (each ranging from 0 to 1).

ccc_border_color =  -- if omitted, become a translucent black; overridable by a chain's border_color
    {0, 0, 0}  -- opaque black
ccc_label_color =  -- if omitted, takes the same value as ccc_border_color
	{0, 0, 1, 0.33}  -- translucent blue
ccc_background_color =  -- if omitted, takes no background (ie fully transparent); overridable by a chain's background_color
    'transparent'
ccc_date_color =  -- if omitted, takes the value of ccc_label_color; overridable by a chain's date_color
    nil  -- as if it's not set at all, ie use the default

ccc_border_thickness = math.round(ccc_side/25)
ccc_today_border_thickness = 2*ccc_border_thickness    -- thickness of today's borders
ccc_full_border_thickness = ccc_today_border_thickness -- thickness of old full cells
ccc_full_border_below = true  -- draws the cell border below the fill (only if full square, not another pattern), making it thinner i.e. less promiment

-- cells can be: empty, full, or partial (partial is when it's filled with a pattern)

-- -- global values for empty cells:
-- ccc_empty_background_color -- if omitted, takes the value of ccc_background_color; overridable by a chain's empty_background_color
-- ccc_empty_date_color -- if omitted, takes the value of ccc_date_color; overridable by a chain's empty_date_color
-- ccc_empty_border_color -- if omitted, takes the value of ccc_date_color; overridable by a chain's empty_border_color
-- ccc_empty_border_thickness -- if omitted, takes the value of ccc_date_color; overridable by a chain's empty_border_thickness

-- -- global values for full cells:
-- ccc_full_background_color -- if omitted, takes the value of ccc_background_color; overridable by a chain's empty_background_color
-- ccc_full_date_color -- if omitted, takes the value of ccc_date_color; overridable by a chain's empty_date_color
-- ccc_full_border_color -- if omitted, takes the value of ccc_border_color; overridable by a chain's empty_border_color
-- ccc_full_border_thickness -- if omitted, takes the value of ccc_border_thickness; overridable by a chain's empty_border_thickness

-- -- global values for partial cells:
-- ccc_partial_background_color -- if omitted, takes the value of ccc_background_color; overridable by a chain's empty_background_color
-- ccc_partial_date_color -- if omitted, takes the value of ccc_date_color; overridable by a chain's empty_date_color
-- ccc_partial_border_color -- if omitted, takes the value of ccc_border_color; overridable by a chain's empty_border_color
-- ccc_partial_border_thickness -- if omitted, takes the value of ccc_border_thickness; overridable by a chain's empty_border_thickness

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

