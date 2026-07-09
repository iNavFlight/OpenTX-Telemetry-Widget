local HORUS = ...

-- Modes: t=text / f=flags for text / w=wave file
local modes = {
	{ t = "! TELEM !", f = 3 },
	{ t = " HORIZON ", f = 0, w = "hrznmd" },
	{ t = "  ANGLE  ", f = 0, w = "anglmd" },
	{ t = "  ACRO   ", f = 0, w = "acromd" },
	{ t = " NOT OK  ", f = 3 }, -- 5
	{ t = "  READY  ", f = 0, w = "ready" },
	{ t = "POS HOLD ", f = 0, w = "poshld" },
	{ t = " WAYPONT ", f = 0, w = "waypt" },
	{ t = " MANUAL  ", f = 0, w = "manmd" },
	{ t = "   RTH   ", f = 3, w = "rtl" }, -- 10
	{ t = "! FAIL  !", f = 3, w = "fson" },
	{ t = "! THROT !", f = 3 },
	{ t = " CRUISE  ", f = 0, w = "cruzmd" },
	{ t = "ANGL HOLD", f = 0, w = "aglhld" },
	{ t = "  LAND   ", f = 0, w = "landin" }, -- 15
	{ t = " GEO NAV ", f = 0, w = "geonav" },
	{ t = " TURTLE  ", f = 0, w = "turtle" },
	{ t = " LOITER  ", f = 0, w = "loiter" },
	{ t = " WP RTH  ", f = 0, w = "wrth" },
	{ t = "CORSE HLD", f = 0, w = "crsh" } -- 20
}

local units = { [0] = "", "V", "A", "mA", "kts", "m/s", "f/s", "kmh", "MPH", "m", HORUS and "ft" or "'" }

local labels = { "Fuel", "Battery", "Current", "Altitude", "Distance" }

local dir = { [0] = "N", "NE", "E", "SE", "S", "SW", "W", "NW" }

return modes, units, labels, dir