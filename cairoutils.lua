require 'cairo'

function get_text_dimensions(cr, txt)
	-- https://bbs.archlinux.org/viewtopic.php?id=223882
	local extents = cairo_text_extents_t:create()
	tolua.takeownership(extents)
	cairo_text_extents(cr, txt, extents)
	return extents.width, extents.height, extents.x_bearing, extents.y_bearing
end

function set_color(cr, color)
	if color == nil then return end
	if #color == 4 then
		cairo_set_source_rgba(cr, unpack(color))
	else
		cairo_set_source_rgb(cr, unpack(color))
	end
end

function set_font(cr, props, override_props)
	override_props = override_props or {}
	local color  = override_props['color']  or props['color']  or {0,0,0}
	local weight = override_props['weight'] or props['weight'] or CAIRO_FONT_WEIGHT_NORMAL
	local slant  = override_props['slant']  or props['slant']  or CAIRO_FONT_SLANT_NORMAL
	local font   = override_props['font']   or props['font']   or "DejaVu Sans Mono"
	local size   = override_props['size']   or props['size']   or 18
	--
	set_color(cr, color)
	cairo_select_font_face(cr, font, slant, weight)
	cairo_set_font_size(cr, size)
end

function do_stroke(cr, color, thickness)  -- path is already drawn
	set_color(cr, color)
	cairo_set_line_width(cr, thickness)
	cairo_stroke(cr)
end

function do_fill(cr, color)  -- path is already drawn
	set_color(cr, color)
	cairo_fill(cr)
end

function show_text(cr, x, y, txt)
	cairo_move_to(cr, x, y)
	cairo_show_text(cr, txt)
end

function show_text_aligned(cr, x, y, txt, align)
	if align and (align['h'] or align['v']) then
		local w, h, xb, yb = get_text_dimensions(cr, txt)
		-- h can be c (centered) or r (right-aligned). left-aligned is the default
		if     align['h'] == 'c' then x = x - w/2 - xb
		elseif align['h'] == 'r' then x = x - w   + align['width']
		end
		-- v can be c (centered) or t (top-aligned) or b (bottom-aligned. baseline-aligned is the default
		if     align['v'] == 'c' then y = y - h/2 - yb
		elseif align['v'] == 't' then y = y + h/2 - yb/2
		-- elseif align['v'] == 'b' then y = y - h   + align['height']  -- UNTESTED
		end
	end
	cairo_move_to(cr, x, y)
	cairo_show_text(cr, txt)
end

function show_text_centered(cr, xc, yc, txt)  -- xc & yc are center points of txt
	local w, h, xb, yb = get_text_dimensions(cr, txt)
	local x = xc - w/2 - xb
	local y = yc - h/2 - yb
	show_text(cr, x, y, txt)
end

function show_text_rightaligned(cr, x, y, txt, max_width)
	local w, h, xb, yb = get_text_dimensions(cr, txt)
	local xt = x - w   + max_width
	local yt = y + h/2 - yb/2
	show_text(cr, xt, yt, txt)
end

function show_text_with_angle(cr, shower_fn, xc, yc, r, deg, txt, df)
	local f = 0.95 + (df or 0)
	if     deg ==   0 then shower_fn(cr, xc + f*r, yc, txt)
	elseif deg == 180 then shower_fn(cr, xc - f*r, yc, txt)
	elseif deg ==  90 then shower_fn(cr, xc, yc - f*r, txt)
	elseif deg == 270 then shower_fn(cr, xc, yc + f*r, txt)
	else
		local x, angle
		if 90 < deg and deg < 270 then
			x, angle = xc - f*r, 180 - deg
		else
			x, angle = xc + f*r, 360 - deg
		end
		-- rotate text: https://stackoverflow.com/a/11475908
		cairo_save(cr)
		-- rotate around clock center: https://stackoverflow.com/a/22961761
		cairo_translate(cr, xc, yc) -- translate origin to the center
		-- cairo_rotate(cr, math.pi/180 * (deg % 180 - 90))
		cairo_rotate(cr, math.pi/180 * angle)
		cairo_translate(cr, -xc, -yc) -- translate origin back
		shower_fn(cr, x, yc, txt)
		cairo_restore(cr)
	end
end

-- conky & cairo

function setup_cairo()
	if conky_window == nil then return end
	local cs = cairo_xlib_surface_create(
		conky_window.display,
		conky_window.drawable,
		conky_window.visual,
		conky_window.width,
		conky_window.height)
	local cr = cairo_create(cs)
	return cr, cs
end

function destroy_cairo(cr, cs)
	cairo_destroy(cr)
	if cs == nil then return end
	cairo_surface_destroy(cs)
end

