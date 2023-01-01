require 'cairoutils'

function _checkered(cr, x0, y0, side, n, reverse)
	local step = side/n
	n = n - 1
	local diff = _if(reverse, 1, 0)
	for i = 0, n do
	for j = 0, n do
		if (i - j) % 2 == diff then
			cairo_rectangle(cr, x0+i*step, y0+j*step, step, step)
		end
	end
	end
end

function _path(cr, x, y, side, ...)  -- each one of ... is a closed path spec, like 'TL BR LB' -- TL & LT are ok
	local args = {...}
	for _, ds in ipairs(args) do
		local path_to = cairo_move_to  -- for the first point, then changed to cairo_line_to
		for i = 1, #ds, 3 do
			local a   = ds:sub(i, i)
			local b   = ds:sub(i+1, i+1)
			local sep = ds:sub(i+2, i+2)
			function has(c) return a == c or b == c end
			local dx, dy
			-- all possible points (TL can be LT, and so on):
			-- TL TC TR
			-- ML MC MR
			-- BL BC BR
			--
			if has('T') then dy = 0      end  -- T => top-point minus y_topleft
			if has('B') then dy = side   end  -- B => bottom-point minus y_topleft
			if has('M') then dy = side/2 end  -- M => middle(y-axis)-point minus y_topleft
			if has('L') then dx = 0      end  -- L => left-point minus x_topleft
			if has('R') then dx = side   end  -- R => right-point minus x_topleft
			if has('C') then dx = side/2 end  -- C => center(x-axis)-point minus x_topleft
			--
			-- secondary points
			if has('F') then dx = side  /4 end  -- F => midpoint between L & C
			if has('S') then dx = side*3/4 end  -- S => midpoint between C & R
			if has('P') then dy = side  /4 end  -- P => midpoint between T & M
			if has('Z') then dy = side*3/4 end  -- Z => midpoint between M & B
			--
			-- tertiary points
			if has('H') then dx = side  /3 end  -- H => 1/3 way between L & R
			if has('K') then dx = side*2/3 end  -- K => 2/3 way between L & R
			if has('N') then dy = side  /3 end  -- N => 1/3 way between T & B
			if has('D') then dy = side*2/3 end  -- D => 2/3 way between T & B
			--
			if dx == nil or dy == nil then
				return
			end
			path_to(cr, x+dx, y+dy)
			if sep == '/' or sep == '\\' then
				path_to = cairo_move_to
			else
				path_to = cairo_line_to
			end
		end
		cairo_close_path(cr)
	end
end

function _circ(cr, xc, yc, r, part, neg)
	if neg then
		function arc(inital, final)
			cairo_arc_negative(cr, xc, yc, r, final, initial)
		end
	else
		function arc(initial, final)
			cairo_arc(cr, xc, yc, r, initial, final)
		end
	end
	-- part: can be `nil` for a full circle
	-- 'N' (north), 'S' (south), 'E' (east), or 'W' (west) for a semicircle
	-- 'NE' (north-east), 'NW', 'SE', or 'SW' for a quadrant
	cairo_move_to(cr, xc, yc)
	if part == nil then      arc(0, math.tau)
	elseif part == 'N' then  arc(0, -math.pi)
	elseif part == 'S' then  arc(-math.pi, 0)
	elseif part == 'E' then  arc(math.pi2, -math.pi2)
	elseif part == 'W' then  arc(-math.pi2, math.pi2)
	elseif part == 'NE' then arc(0, -math.pi)
	elseif part == 'NW' then arc(0, -math.pi)
	elseif part == 'SE' then arc(-math.pi, 0)
	elseif part == 'SW' then arc(-math.pi, 0)
	end
end

function _circles(cr, x, y, s, n, scale)
	local R = s/n/2
	local r = s/n/2 * unless_nil(scale, 1)
	for i = 1, n do
	for j = 1, n do
		_circ(cr,
			x + s * (i-1) / n + R,
			y + s * (j-1) / n + R,
			r)
	end
	end
	if reverse then
		_path(cr, x, y, s, 'TL BL BR TR')
	end
end

function _nought(cr, x, y, s, scale)
	local R = s/2
	local r = s/2 * unless_nil(scale, 1)
	local xc = x+R
	local yc = y+R
	_circ(cr, xc, yc, r)
	_circ(cr, xc, yc, r*0.47, nil, true)
end


local _paths = {
	fast_forward          = {_path, 'TL MC TC MR BC MC BL'},
	fast_backward         = {_path, 'TR BR MC BC ML TC MC'},
	fast_upward           = {_path, 'ML TC MR MC BR BL MC'},
	fast_downward         = {_path, 'TL TR MC MR BC ML MC'},
	downward              = {_path, 'TL TR BC'},
	upward                = {_path, 'BL TC BR'},
	backward              = {_path, 'TR BR ML'},
	forward               = {_path, 'TL MR BL'},
	bottom_left_triangle  = {_path, 'TL BR BL'},
	top_right_triangle    = {_path, 'TL BR TR'},
	bottom_right_triangle = {_path, 'TR BL BR'},
	top_left_triangle     = {_path, 'TR BL TL'},
	hourglass             = {_path, 'TL TR MC BR BL MC'},
	right_most            = {_path, 'TL TR BR BL ML BC MC MR TC MC ML'},
	right_least           = {_path, 'MC ML BC', 'MC MR TC'},
	left_least            = {_path, 'TC ML MC BC MR MC TC'},
	-- house_with_bowtie  = {_path, 'TL TR BR BL MC ML BC MC MR TC ML'},
	left_most             = {_path, 'TL TR BR BL ML MC BC MR MC TC ML'},
	diamond               = {_path, 'TC MR BC ML'},
	slash                 = {_path, 'TC TR BC BL'},
	backslash             = {_path, 'TC BR BC TL'},
	-- left_road             = {_path, 'TL BR BC'},
	-- right_road            = {_path, 'BL TR BC'},
	up_arrow              = {_path, 'MC BL TC BR'},
	down_arrow            = {_path, 'TL MC TR BC'},
	right_arrow           = {_path, 'TL MR BL MC'},
	left_arrow            = {_path, 'TR MC BR ML'},
	pyramids              = {_path, 'MR BR BL ZL PF ZC TS'},
	-- kite               = {_path, 'MR TC BL'},
	cross                 = {_path, 'TL TH NC TK TR MK BR BK DC BH BL MH'},
	bigcircle             = {_circles, 1},
	four_circles          = {_circles, 2},
	circle                = {_circles, 1, 0.75},
	smallcircle           = {_circles, 1, 0.5},
	bignought             = {_nought},
	nought                = {_nought, 0.75},
	smallnought           = {_nought, 0.5},
	bar                   = {_path, 'NL NR DR DL'},
	pipe                  = {_path, 'TH TK BK BH'},
}

local mkpath = {}  -- all take (cr, x_topleft, y_topleft)
for pathname, pathspec in pairs(_paths) do
	local fn = table.remove(pathspec, 1)
	mkpath[pathname] = function(cr, x, y, side)
		fn(cr, x, y, side, unpack(pathspec))
	end
	mkpath['reverse_'..pathname] = function(cr, x, y, side)
		_path(cr, x, y, side, 'TL BL BR TR')
		fn(cr, x, y, side, unpack(pathspec))
	end
end
for i = 2, 9 do
	mkpath['checkered'..i]         = function(cr, x, y, side) _checkered(cr, x, y, side, i) end
	mkpath['reverse_checkered'..i] = function(cr, x, y, side) _checkered(cr, x, y, side, i, true) end
end

function draw_square(cr, x_topleft, y_topleft, side, a)
	local fill = a['fill']
	local border_first =
		(fill == true and a['full_border_below']) or
		(a['background_color'] ~= nil and a['border_below_background'])
	function full_square()
		cairo_rectangle(cr, x_topleft, y_topleft, side, side)
	end
	function border()
		full_square(); do_stroke(cr, a['border_color'], a['border_thickness'])
	end
	function background()
		if a['background_color'] == nil or a['background_color'] == false then return end
		full_square(); do_fill(cr, a['background_color'])
	end
	function pattern()
		if fill == nil or fill == false then return end
		if fill == true then
			full_square()
		elseif mkpath[fill] ~= nil then
			mkpath[fill](cr, x_topleft, y_topleft, side)
		else
			_path(cr, x_topleft, y_topleft, side, fill)
		end
		do_fill(cr, a['fill_color'])
	end
	--
	if border_first then
		border()
		background()
		pattern()
	else
		background()
		pattern()
		border()
	end
end

PREVIEW_SHAPES = {
	'cross', 'reverse_cross', 'nought', 'circle',
	'smallnought', 'bignought', 'smallcircle', 'bigcircle',
	'bar', 'reverse_bar', 'pipe', 'reverse_pipe',
	'bottom_left_triangle', 'top_right_triangle', 'bottom_right_triangle', 'top_left_triangle',
	'right_most', 'right_least', 'left_least', 'left_most',
	'hourglass', 'reverse_hourglass', 'diamond', 'reverse_diamond',
	'up_arrow', 'down_arrow', 'right_arrow', 'left_arrow',
	'reverse_up_arrow', 'reverse_down_arrow', 'reverse_right_arrow', 'reverse_left_arrow',
	'forward', 'backward', 'upward', 'downward',
	'reverse_forward', 'reverse_backward', 'reverse_upward', 'reverse_downward',
	'fast_forward', 'fast_backward', 'fast_upward', 'fast_downward',
	'reverse_fast_forward', 'reverse_fast_backward', 'reverse_fast_upward', 'reverse_fast_downward',
	'slash', 'backslash', 'reverse_slash', 'reverse_backslash',
	-- 'right_road', 'left_road', 'reverse_right_road', 'reverse_left_road',
	'checkered2', 'reverse_checkered2', 'checkered3', 'reverse_checkered3',
	'checkered4', 'reverse_checkered4', 'checkered5', 'reverse_checkered5',
	'checkered6', 'reverse_checkered6', 'checkered7', 'reverse_checkered7',
}
