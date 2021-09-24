local iNav = nil
local options = {
	{ "Restore", BOOL, 1},
	{ "Text", COLOR, WHITE},
	{ "Warning", COLOR, YELLOW}
}

local TELE_PATH = "/SCRIPTS/TELEMETRY/"
local v, r, m, i, e = getVersion()
if string.sub(r, -4) == "simu" then
   loadScript(TELE_PATH .. "iNav", "bt")(zone, options)
end

-- Run once at the creation of the widget
local function create(zone, options)
   local iNav = loadScript(TELE_PATH .. "iNav","bt")(zone, options)
   iNav.background()
   return iNav
end

-- This function allow updates when you change widgets settings
local function update(widget, options)
   widget.update( options)
end

-- Called periodically when custom telemetry screen containing widget is visible.
local function refresh(widget, event, touchState)
   widget.run(event, touchState)
end

-- Called periodically when custom telemetry screen containing widget is not visible
local function background(widget)
  widget.background()
end

return {
  name = "iNav",
  create = create,
  refresh = refresh,
  options = options,
  update = update,
  background = background
}
