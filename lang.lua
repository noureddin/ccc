-- lua

function _if(cond, if_true, if_false)
	if cond then return if_true else return if_false end
end

function unless_nil(primary, secondary)
	if primary ~= nil then return primary else return secondary end
end

-- lua/math

math.tau = 2*math.pi
math.pi2 =   math.pi/2

-- https://stackoverflow.com/a/26777901
-- identical to https://wiki.multitheftauto.com/wiki/Math.round w/o the optional argument
function math.round(x)
	if x >= 0 then
		return math.floor(x + 0.5)
	else
		return math.ceil(x - 0.5)
	end
end

-- https://wiki.multitheftauto.com/wiki/Math.clamp
function math.clamp(number, min, max)
	if number < min then
		return min
	elseif number > max then
		return max
	end
	return number
end

-- lua/table

function table.min_key(tbl)
	local m
	for k, v in pairs(tbl) do
		if m == nil or m > k then
			m = k
		end
	end
	return m
end

