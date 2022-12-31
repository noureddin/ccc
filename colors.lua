--[[
--    colors are passed to the color() function below.
--    colors can be one of these formats:
--    - a named css color: any valid css (till css 4) color, in small case, like 'aliceblue'
--    - a named tango color: the tango palette, like 'scarletred1'
--    - a hex (html) color: like '#f00' (for red) or '#707070' (for gray)
--    - a 3-tuple of [0-1] for RGB: like {1, 0, 0} for red (note: no quotes)
--    - a 4-tuple of [0-1] for RGBA: like {0, 0, 0, 0.33} for translucent black (note: no quotes)
--]]

local clrs = {

	transparent  = {0, 0, 0, 0},

	-- css:
	aliceblue            = {0.941176, 0.972549, 1.000000},
	antiquewhite         = {0.980392, 0.921569, 0.843137},
	aqua                 = {0.000000, 1.000000, 1.000000},
	aquamarine           = {0.498039, 1.000000, 0.831373},
	azure                = {0.941176, 1.000000, 1.000000},
	beige                = {0.960784, 0.960784, 0.862745},
	bisque               = {1.000000, 0.894118, 0.768627},
	black                = {0.000000, 0.000000, 0.000000},
	blanchedalmond       = {1.000000, 0.921569, 0.803922},
	blue                 = {0.000000, 0.000000, 1.000000},
	blueviolet           = {0.541176, 0.168627, 0.886275},
	brown                = {0.647059, 0.164706, 0.164706},
	burlywood            = {0.870588, 0.721569, 0.529412},
	cadetblue            = {0.372549, 0.619608, 0.627451},
	chartreuse           = {0.498039, 1.000000, 0.000000},
	chocolate            = {0.823529, 0.411765, 0.117647},
	coral                = {1.000000, 0.498039, 0.313725},
	cornflowerblue       = {0.392157, 0.584314, 0.929412},
	cornsilk             = {1.000000, 0.972549, 0.862745},
	crimson              = {0.862745, 0.078431, 0.235294},
	cyan                 = {0.000000, 1.000000, 1.000000},
	darkblue             = {0.000000, 0.000000, 0.545098},
	darkcyan             = {0.000000, 0.545098, 0.545098},
	darkgoldenrod        = {0.721569, 0.525490, 0.043137},
	darkgray             = {0.662745, 0.662745, 0.662745},
	darkgreen            = {0.000000, 0.392157, 0.000000},
	darkgrey             = {0.662745, 0.662745, 0.662745},
	darkkhaki            = {0.741176, 0.717647, 0.419608},
	darkmagenta          = {0.545098, 0.000000, 0.545098},
	darkolivegreen       = {0.333333, 0.419608, 0.184314},
	darkorange           = {1.000000, 0.549020, 0.000000},
	darkorchid           = {0.600000, 0.196078, 0.800000},
	darkred              = {0.545098, 0.000000, 0.000000},
	darksalmon           = {0.913725, 0.588235, 0.478431},
	darkseagreen         = {0.560784, 0.737255, 0.560784},
	darkslateblue        = {0.282353, 0.239216, 0.545098},
	darkslategray        = {0.184314, 0.309804, 0.309804},
	darkslategrey        = {0.184314, 0.309804, 0.309804},
	darkturquoise        = {0.000000, 0.807843, 0.819608},
	darkviolet           = {0.580392, 0.000000, 0.827451},
	deeppink             = {1.000000, 0.078431, 0.576471},
	deepskyblue          = {0.000000, 0.749020, 1.000000},
	dimgray              = {0.411765, 0.411765, 0.411765},
	dimgrey              = {0.411765, 0.411765, 0.411765},
	dodgerblue           = {0.117647, 0.564706, 1.000000},
	firebrick            = {0.698039, 0.133333, 0.133333},
	floralwhite          = {1.000000, 0.980392, 0.941176},
	forestgreen          = {0.133333, 0.545098, 0.133333},
	fuchsia              = {1.000000, 0.000000, 1.000000},
	gainsboro            = {0.862745, 0.862745, 0.862745},
	ghostwhite           = {0.972549, 0.972549, 1.000000},
	gold                 = {1.000000, 0.843137, 0.000000},
	goldenrod            = {0.854902, 0.647059, 0.125490},
	gray                 = {0.501961, 0.501961, 0.501961},
	green                = {0.000000, 0.501961, 0.000000},
	greenyellow          = {0.678431, 1.000000, 0.184314},
	grey                 = {0.501961, 0.501961, 0.501961},
	honeydew             = {0.941176, 1.000000, 0.941176},
	hotpink              = {1.000000, 0.411765, 0.705882},
	indianred            = {0.803922, 0.360784, 0.360784},
	indigo               = {0.294118, 0.000000, 0.509804},
	ivory                = {1.000000, 1.000000, 0.941176},
	khaki                = {0.941176, 0.901961, 0.549020},
	lavender             = {0.901961, 0.901961, 0.980392},
	lavenderblush        = {1.000000, 0.941176, 0.960784},
	lawngreen            = {0.486275, 0.988235, 0.000000},
	lemonchiffon         = {1.000000, 0.980392, 0.803922},
	lightblue            = {0.678431, 0.847059, 0.901961},
	lightcoral           = {0.941176, 0.501961, 0.501961},
	lightcyan            = {0.878431, 1.000000, 1.000000},
	lightgoldenrodyellow = {0.980392, 0.980392, 0.823529},
	lightgray            = {0.827451, 0.827451, 0.827451},
	lightgreen           = {0.564706, 0.933333, 0.564706},
	lightgrey            = {0.827451, 0.827451, 0.827451},
	lightpink            = {1.000000, 0.713725, 0.756863},
	lightsalmon          = {1.000000, 0.627451, 0.478431},
	lightseagreen        = {0.125490, 0.698039, 0.666667},
	lightskyblue         = {0.529412, 0.807843, 0.980392},
	lightslategray       = {0.466667, 0.533333, 0.600000},
	lightslategrey       = {0.466667, 0.533333, 0.600000},
	lightsteelblue       = {0.690196, 0.768627, 0.870588},
	lightyellow          = {1.000000, 1.000000, 0.878431},
	lime                 = {0.000000, 1.000000, 0.000000},
	limegreen            = {0.196078, 0.803922, 0.196078},
	linen                = {0.980392, 0.941176, 0.901961},
	magenta              = {1.000000, 0.000000, 1.000000},
	maroon               = {0.501961, 0.000000, 0.000000},
	mediumaquamarine     = {0.400000, 0.803922, 0.666667},
	mediumblue           = {0.000000, 0.000000, 0.803922},
	mediumorchid         = {0.729412, 0.333333, 0.827451},
	mediumpurple         = {0.576471, 0.439216, 0.858824},
	mediumseagreen       = {0.235294, 0.701961, 0.443137},
	mediumslateblue      = {0.482353, 0.407843, 0.933333},
	mediumspringgreen    = {0.000000, 0.980392, 0.603922},
	mediumturquoise      = {0.282353, 0.819608, 0.800000},
	mediumvioletred      = {0.780392, 0.082353, 0.521569},
	midnightblue         = {0.098039, 0.098039, 0.439216},
	mintcream            = {0.960784, 1.000000, 0.980392},
	mistyrose            = {1.000000, 0.894118, 0.882353},
	moccasin             = {1.000000, 0.894118, 0.709804},
	navajowhite          = {1.000000, 0.870588, 0.678431},
	navy                 = {0.000000, 0.000000, 0.501961},
	oldlace              = {0.992157, 0.960784, 0.901961},
	olive                = {0.501961, 0.501961, 0.000000},
	olivedrab            = {0.419608, 0.556863, 0.137255},
	orange               = {1.000000, 0.647059, 0.000000},
	orangered            = {1.000000, 0.270588, 0.000000},
	orchid               = {0.854902, 0.439216, 0.839216},
	palegoldenrod        = {0.933333, 0.909804, 0.666667},
	palegreen            = {0.596078, 0.984314, 0.596078},
	paleturquoise        = {0.686275, 0.933333, 0.933333},
	palevioletred        = {0.858824, 0.439216, 0.576471},
	papayawhip           = {1.000000, 0.937255, 0.835294},
	peachpuff            = {1.000000, 0.854902, 0.725490},
	peru                 = {0.803922, 0.521569, 0.247059},
	pink                 = {1.000000, 0.752941, 0.796078},
	plum                 = {0.866667, 0.627451, 0.866667},
	powderblue           = {0.690196, 0.878431, 0.901961},
	purple               = {0.501961, 0.000000, 0.501961},
	rebeccapurple        = {0.400000, 0.200000, 0.600000},
	red                  = {1.000000, 0.000000, 0.000000},
	rosybrown            = {0.737255, 0.560784, 0.560784},
	royalblue            = {0.254902, 0.411765, 0.882353},
	saddlebrown          = {0.545098, 0.270588, 0.074510},
	salmon               = {0.980392, 0.501961, 0.447059},
	sandybrown           = {0.956863, 0.643137, 0.376471},
	seagreen             = {0.180392, 0.545098, 0.341176},
	seashell             = {1.000000, 0.960784, 0.933333},
	sienna               = {0.627451, 0.321569, 0.176471},
	silver               = {0.752941, 0.752941, 0.752941},
	skyblue              = {0.529412, 0.807843, 0.921569},
	slateblue            = {0.415686, 0.352941, 0.803922},
	slategray            = {0.439216, 0.501961, 0.564706},
	slategrey            = {0.439216, 0.501961, 0.564706},
	snow                 = {1.000000, 0.980392, 0.980392},
	springgreen          = {0.000000, 1.000000, 0.498039},
	steelblue            = {0.274510, 0.509804, 0.705882},
	tan                  = {0.823529, 0.705882, 0.549020},
	teal                 = {0.000000, 0.501961, 0.501961},
	thistle              = {0.847059, 0.749020, 0.847059},
	tomato               = {1.000000, 0.388235, 0.278431},
	turquoise            = {0.250980, 0.878431, 0.815686},
	violet               = {0.933333, 0.509804, 0.933333},
	wheat                = {0.960784, 0.870588, 0.701961},
	white                = {1.000000, 1.000000, 1.000000},
	whitesmoke           = {0.960784, 0.960784, 0.960784},
	yellow               = {1.000000, 1.000000, 0.000000},
	yellowgreen          = {0.603922, 0.803922, 0.196078},

	-- tango:
	butter1              = {0.988235, 0.913725, 0.309804},
	butter2              = {0.929412, 0.831373, 0.000000},
	butter3              = {0.768627, 0.627451, 0.000000},
	chameleon1           = {0.541176, 0.886275, 0.203922},
	chameleon2           = {0.450980, 0.823529, 0.086275},
	chameleon3           = {0.305882, 0.603922, 0.023529},
	orange1              = {0.988235, 0.686275, 0.243137},
	orange2              = {0.960784, 0.474510, 0.000000},
	orange3              = {0.807843, 0.360784, 0.000000},
	skyblue1             = {0.447059, 0.623529, 0.811765},
	skyblue2             = {0.203922, 0.396078, 0.643137},
	skyblue3             = {0.125490, 0.290196, 0.529412},
	plum1                = {0.678431, 0.498039, 0.658824},
	plum2                = {0.458824, 0.313725, 0.482353},
	plum3                = {0.360784, 0.207843, 0.400000},
	chocolate1           = {0.913725, 0.725490, 0.431373},
	chocolate2           = {0.756863, 0.490196, 0.066667},
	chocolate3           = {0.560784, 0.349020, 0.007843},
	scarletred1          = {0.937255, 0.160784, 0.160784},
	scarletred2          = {0.800000, 0.000000, 0.000000},
	scarletred3          = {0.643137, 0.000000, 0.000000},
	aluminium1           = {0.933333, 0.933333, 0.925490},
	aluminium2           = {0.827451, 0.843137, 0.811765},
	aluminium3           = {0.729412, 0.741176, 0.713725},
	aluminium4           = {0.533333, 0.541176, 0.521569},
	aluminium5           = {0.333333, 0.341176, 0.325490},
	aluminium6           = {0.180392, 0.203922, 0.211765},

}

require 'lang'

local hex_scales = { 15, 255, 4095 }  -- max val of color; 16**n - 1

function hex_to_color(hex)                    -- #rgb #rgba #rrggbb #rrggbbaa
	local step = math.floor((#hex - 1) / 3)   --  1    1     2       2
	local scale = hex_scales[step]
	if scale == nil then return nil end
	local r_abs = tonumber(hex:sub(2+0*step, 2+0*step+step-1), 16)
	local g_abs = tonumber(hex:sub(2+1*step, 2+1*step+step-1), 16)
	local b_abs = tonumber(hex:sub(2+2*step, 2+2*step+step-1), 16)
	local a_abs = tonumber(hex:sub(2+3*step, 2+3*step+step-1), 16)
	if r_abs == nil or g_abs == nil or b_abs == nil then
		return nil
	end
	local alpha; if a_abs ~= nil then alpha = a_abs / scale end
	return {
		r_abs / scale,
		g_abs / scale,
		b_abs / scale,
		alpha,
	}
end

function color(name)
	if name == nil or type(name) == 'table' then
		return name  -- nil or already a table of values
	elseif clrs[name] then
		return clrs[name]
	elseif type(name) == 'string' and name:sub(1,1) == '#' then
		return hex_to_color(name)
	else
		return nil
	end
end
