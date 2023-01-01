require 'cairo'

require 'colors'  -- color() & lang.lua
require 'fill'    -- draw_square() & PREVIEW_SHAPES
require 'time'
require 'cairoutils'

conky = {}
require 'ccc'  -- the ccc_* parameters

local WEEK_START     = ccc_week_start or 1
local SHOW_DATE      = unless_nil(ccc_show_date, true)
local DATE_DAY_ONLY  = unless_nil(ccc_date_day_only, true)
local FORCE_START_ON = ccc_force_start_on

local SIDE = ccc_side or 25

-- cells can be: empty, full, or partial

local         BORDER_THICKNESS =         ccc_border_thickness or math.round(SIDE/25)
local   EMPTY_BORDER_THICKNESS =   ccc_empty_border_thickness or BORDER_THICKNESS
local    FULL_BORDER_THICKNESS =    ccc_full_border_thickness or BORDER_THICKNESS
local PARTIAL_BORDER_THICKNESS = ccc_partial_border_thickness or BORDER_THICKNESS
local   TODAY_BORDER_THICKNESS =   ccc_today_border_thickness or BORDER_THICKNESS*2

local         BORDER_COLOR = color(        ccc_border_color) or {0, 0, 0, 0.33}
local   EMPTY_BORDER_COLOR = color(  ccc_empty_border_color) or BORDER_COLOR
local    FULL_BORDER_COLOR = color(   ccc_full_border_color) or BORDER_COLOR
local PARTIAL_BORDER_COLOR = color(ccc_partial_border_color) or BORDER_COLOR
local   TODAY_BORDER_COLOR = color(  ccc_today_border_color) or BORDER_COLOR

local LABEL_COLOR = color(ccc_label_color) or BORDER_COLOR

local         DATE_COLOR = color(        ccc_date_color) or LABEL_COLOR
local   EMPTY_DATE_COLOR = color(  ccc_empty_date_color) or DATE_COLOR
local    FULL_DATE_COLOR = color(   ccc_full_date_color) or DATE_COLOR
local PARTIAL_DATE_COLOR = color(ccc_partial_date_color) or DATE_COLOR

local         BACKGROUND_COLOR = color(        ccc_background_color) -- defaults to nil
local   EMPTY_BACKGROUND_COLOR = color(  ccc_empty_background_color) or BACKGROUND_COLOR
local    FULL_BACKGROUND_COLOR = color(   ccc_full_background_color) or BACKGROUND_COLOR
local PARTIAL_BACKGROUND_COLOR = color(ccc_partial_background_color) or BACKGROUND_COLOR

local FULL_BORDER_BELOW = ccc_full_border_below

local LABEL_FONT = {
	font   = ccc_label_font or "DejaVu Sans Mono",
	color  = LABEL_COLOR,
	size   = SIDE,
	slant  = CAIRO_FONT_SLANT_NORMAL,
	weight = CAIRO_FONT_WEIGHT_BOLD,
}

local DATE_FONT = {
	font   = ccc_date_font or LABEL_FONT['font'],
	color  = DATE_COLOR,
	slant  = CAIRO_FONT_SLANT_NORMAL,
	weight = CAIRO_FONT_WEIGHT_NORMAL,
	-- size & other attribs are automatically determined
}

local LABEL_X = ccc_topleft_x or 10
local LABEL_WIDTH  -- call fix_font_size() after initializing cairo

local X_TOPLEFT -- = LABEL_X + LABEL_WIDTH + GAP
local Y_TOPLEFT = ccc_topleft_y or 10

local       GAP = ccc_gap       or math.floor(SIDE/3)
local LABEL_GAP = ccc_label_gap or GAP
local  WEEK_GAP = ccc_week_gap  or 2*GAP
local CHAIN_GAP = ccc_chain_gap or math.round(1.5*GAP)

local FILLS = ccc_fills
local DEFAULT_FILL = ccc_default_fill

local MAX_IN_ROW = ccc_max_in_row or 4
local MAX_ROWS = ccc_max_rows or 3

local MAXROW = MAX_IN_ROW * 7
local MAXDAY = MAX_ROWS * MAXROW  -- maximum number of days representable

function first_weekstart_on_or_before_mjd(mjd)
	-- we want the WEEK_START ([0-6]) day that is on or immediately before mjd
	return mjd - math.abs(7 + weekday_of_mjd(mjd) - WEEK_START % 7) % 7
end

local MOST_RECENT_WEEKSTART_MJD  = first_weekstart_on_or_before_mjd( now_mjd() )
local MOST_DISTANT_WEEKSTART_MJD = first_weekstart_on_or_before_mjd( now_mjd() - MAXDAY + 8 )

function first_weekstart_epoch()
	if ccc_preview_fills then return 0 end
	if FORCE_START_ON then
		return mjd_to_epoch( first_weekstart_on_or_before_mjd( intdate_to_mjd( FORCE_START_ON ) ) )
	end
	local first_date = 99990000
	for i = 1, #ccc_chains do
		local date = table.min_key(ccc_chains[i]['streaks'])
		if date and first_date > date then
			first_date = date
		end
	end
	return mjd_to_epoch(math.clamp(
		first_weekstart_on_or_before_mjd( intdate_to_mjd(first_date) ),
		MOST_DISTANT_WEEKSTART_MJD,  -- [min] earlier than possible
		MOST_RECENT_WEEKSTART_MJD))  -- [max] later than possible (eg, no streaks at all)
end

local FIRST_WEEKSTART_EPOCH = normalize_to_localtime_midnight(first_weekstart_epoch())

function fix_font_size(cr)  -- must be called once after initializing cairo
	if LABEL_WIDTH then return end
	-- label
	set_font(cr, LABEL_FONT)
	LABEL_WIDTH = 0
	for i = 1, #ccc_chains do
		local w, h, xb, yb = get_text_dimensions(cr, ccc_chains[i]['label'])
		if LABEL_WIDTH < w then
			LABEL_WIDTH = w
		end
	end
	X_TOPLEFT = LABEL_X + LABEL_WIDTH + GAP
	-- date
	set_font(cr, DATE_FONT)
	local height = _if(DATE_DAY_ONLY, SIDE, math.floor(SIDE/2))
	local width = math.floor(SIDE*0.9 - 2*BORDER_THICKNESS)
	local x_off_to_center = SIDE/2
	local y_off_to_center = _if(DATE_DAY_ONLY, SIDE/2, SIDE/4)
	for size = 1, height+100 do
		cairo_set_font_size(cr, size)
		local w, h, xb, yb = get_text_dimensions(cr, '88')
		if h >= height or w >= width then
			return
		else
			LABEL_FONT['size'] = size * 1.333
			DATE_FONT['size'] = size
			DATE_FONT['x_off'] = -w/2 - xb + x_off_to_center
			DATE_FONT['y_off'] = -h/2 - yb + y_off_to_center
			DATE_FONT['height'] = h
		end
	end
end

function draw_label(cr, y, txt)
	set_font(cr, LABEL_FONT)
	show_text_aligned(cr,
		LABEL_X,
		y+DATE_FONT['y_off'],  -- on the same baseline as the date
		txt,
		{ h='r', width=LABEL_WIDTH })  -- right aligned
end

function show_date(cr, x_topleft, y_topleft, month, day, font_overrides)
	set_font(cr, DATE_FONT, font_overrides)
	month = tostring(month); if #month == 1 then month = ' ' .. month end
	day   = tostring(day);   if #day   == 1 then day   = ' ' .. day   end
	local x = x_topleft + DATE_FONT['x_off']
	local y = y_topleft + DATE_FONT['y_off']
	show_text(cr, x, y, day)
	if not DATE_DAY_ONLY then
		y = y + DATE_FONT['height']
		show_text(cr, x, y, month)
	end
end

function draw_cell(cr, a)
	draw_square(cr, a['x_topleft'], a['y_topleft'], SIDE, {
		border_thickness = a['border_thickness'],
		border_color = a['border_color'],
		fill = a['fill'],
		fill_color = a['fill_color'],
		background_color = a['background_color'],
		full_border_below = FULL_BORDER_BELOW,
	})
	if SHOW_DATE == false then return end
	show_date(cr, a['x_topleft'], a['y_topleft'], a['month'], a['day'], {
		weight = a['weight'],
		color = a['date_color'],
	})
end

function parse_streaks(streaks, chain_fills, global_fills)
	chain_fills = chain_fills or {}
	global_fills = global_fills or {}
	local has = {}
	for bgn, len in pairs(streaks) do
		if tonumber(len) ~= nil then
			for i = 0, len - 1 do
				has[i + intdate_to_mjd(bgn)] = true
			end
		else -- len is a not a full cell
			has[intdate_to_mjd(bgn)] = chain_fills[len] or global_fills[len] or len
		end
	end
	local start_mjd = table.min_key(has) or 0
	local start_epoch = mjd_to_epoch(start_mjd)
	--
	local today = normalize_to_localtime_midnight(now_epoch())
	local ep    = normalize_to_localtime_midnight(start_epoch)
	start_epoch = ep
	local dy = start_mjd
	--
	local off = (start_epoch - FIRST_WEEKSTART_EPOCH) / SECONDS_IN_DAY
	ep = start_epoch - off*SECONDS_IN_DAY
	dy = start_mjd   - off
	return { has = has, today = today, myepoch = ep, myepochday = dy }
end

function draw_chain(cr, label, y_offset, style, streaks, inverse, dfill)
	local has   = streaks['has']
	local today = streaks['today']
	local ep    = streaks['myepoch']
	local dy    = streaks['myepochday']
	--
	local x, y = X_TOPLEFT, Y_TOPLEFT + y_offset
	draw_label(cr, y, label)
	--
	local n = 0
	local function draw(fill)
		if inverse and (fill == nil or fill == true) then fill = not fill end
		if dfill ~= nil and fill == true then fill = dfill end
		if fill == 'full' then fill = true end  -- draw_square doesn't understand fill == 'full'
		local month, day = os.date("%m", ep), os.date("%d", ep)
		local is_today = ep == today
		--
		local function select_style(what)
			return _if(is_today,      style['today_'..what],
			       _if(fill == true,  style['full_'..what],
			       _if(fill,          style['partial_'..what],
			                          style['empty_'..what])))
		end
		--
		draw_cell(cr, {
				x_topleft = x,
				y_topleft = y,
				weight = _if(is_today, CAIRO_FONT_WEIGHT_BOLD, CAIRO_FONT_WEIGHT_NORMAL),
				border_thickness = select_style('border_thickness'),
				border_color = select_style('border_color'),
				date_color = select_style('date_color'),
				background_color = select_style('background_color'),
				fill_color = style['color'],
				fill = fill,
				month = month,
				day = day,
			})
		--
		ep = ep + SECONDS_IN_DAY
		dy = dy + 1
		n = n + 1
		if n % MAXROW == 0 then
			x, y = X_TOPLEFT, y + SIDE + GAP
		else
			x = x + SIDE + _if(n % 7 == 0, WEEK_GAP, GAP)
		end
	end
	--
	while ep <= today do
		draw(has[dy])
	end
	--
	return y - Y_TOPLEFT + CHAIN_GAP + _if(x == X_TOPLEFT, 0, SIDE + GAP)
end

function draw_chains(cr)

	fix_font_size(cr)

	local y_offset = 0
	for i = 1, #ccc_chains do
		local ch = ccc_chains[i]
		local label = ch['label']
		local background_color  = color(ch['background_color']) or BACKGROUND_COLOR
		local date_color        = color(ch['date_color']) or DATE_COLOR
		local border_color      = color(ch['border_color']) or BORDER_COLOR
		local border_thickness  = ch['border_thickness'] or BORDER_THICKNESS
		local style = {
			color                  = color(ch['color']),
			today_border_color     = color(ch['today_border_color']) or TODAY_BORDER_COLOR,
			today_border_thickness = ch['today_border_thickness'] or TODAY_BORDER_THICKNESS,
			full_border_below      = ch['full_border_below'],

			empty_background_color   = color(ch['empty_background_color'])   or background_color or EMPTY_BACKGROUND_COLOR,
			full_background_color    = color(ch['full_background_color'])    or background_color or FULL_BACKGROUND_COLOR,
			partial_background_color = color(ch['partial_background_color']) or background_color or PARTIAL_BACKGROUND_COLOR,

			empty_date_color   = color(ch['empty_date_color'])   or date_color or EMPTY_DATE_COLOR,
			full_date_color    = color(ch['full_date_color'])    or date_color or FULL_DATE_COLOR,
			partial_date_color = color(ch['partial_date_color']) or date_color or PARTIAL_DATE_COLOR,

			empty_border_color   = color(ch['empty_border_color'])   or border_color or EMPTY_BORDER_COLOR,
			full_border_color    = color(ch['full_border_color'])    or border_color or FULL_BORDER_COLOR,
			partial_border_color = color(ch['partial_border_color']) or border_color or PARTIAL_BORDER_COLOR,

			empty_border_thickness   = ch['empty_border_thickness']   or border_thickness or EMPTY_BORDER_THICKNESS,
			full_border_thickness    = ch['full_border_thickness']    or border_thickness or FULL_BORDER_THICKNESS,
			partial_border_thickness = ch['partial_border_thickness'] or border_thickness or PARTIAL_BORDER_THICKNESS,
		}

		local streaks  = parse_streaks(ch['streaks'], ch['fills'], FILLS)
		local inverse  = ch['inverse']
		local dfill    = ch['default_fill'] or DEFAULT_FILL
		y_offset = draw_chain(cr, label, y_offset, style, streaks, inverse, dfill)
	end

end

function preview_fills(cr)

	-- determine column width
	set_font(cr, LABEL_FONT, {size=LABEL_FONT['size']*3/4, color={0,0,0}})
	local ww = 0
	for i, t in ipairs(PREVIEW_SHAPES) do
		local w, h, xb, yb = get_text_dimensions(cr, t)
		if w > ww then ww = w end
	end

	local MAX = 4  -- in a single row

	local endgap = 3
	local firstgap = _if(ccc_preview_symmetric_gap, endgap, 1)

	function x0(c) return firstgap*GAP + c*(SIDE+endgap*GAP+ww) end
	function y0(c) return firstgap*GAP + c*(SIDE+endgap*GAP) end

	if ccc_preview_background then
		local xside = x0(MAX)
		local yside = y0(math.ceil(#PREVIEW_SHAPES / MAX))
		cairo_rectangle(cr, 0, 0, xside, yside)
		set_color(cr, color(ccc_preview_background))
		cairo_fill(cr)
	end

	for i, t in ipairs(PREVIEW_SHAPES) do
		local x = x0((i-1)%MAX)
		local y = y0(math.floor((i-1)/MAX))
		draw_square(cr, x, y, SIDE, {
			fill = t,
			fill_color = color(ccc_preview_cell_color) or color('#1034A6'),
			border_thickness = ccc_preview_cell_border_thickness or BORDER_THICKNESS,
			border_color = color(ccc_preview_cell_border_color) or BORDER_COLOR,
			background_color = color(ccc_preview_cell_backgroundcolor) or BACKGROUND_COLOR,
		})
		set_color(cr, color(ccc_preview_label_color) or {0,0,0})
		show_text(cr, x + SIDE*5/4, y + SIDE*3/4, t)
	end

end


function conky_draw_chains()
	local cr, cs = setup_cairo()
	if cr == nil or tonumber(conky_parse('${updates}')) < 1 then return end
	--
	if ccc_preview_fills then
		preview_fills(cr)
	else
		draw_chains(cr)
	end
	--
	destroy_cairo(cr, cs)
end

