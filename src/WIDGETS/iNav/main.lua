local iNav = nil
local options = {
	{ "Restore", BOOL, 1},
	{ "Text", COLOR, WHITE},
	{ "Warning", COLOR, YELLOW}
}

local TELE_PATH = "/SCRIPTS/TELEMETRY/"

-- Guard against getVersion() ever returning something unexpected: this runs
-- unconditionally every time EdgeTX scans /WIDGETS/, before the widget is
-- even added to a screen. If it throws, EdgeTX silently drops the widget
-- from the list with no error shown, so it must never be allowed to fail.
pcall(function()
   local v, r, m, i, e = getVersion()
   if r and string.sub(r, -4) == "simu" then
      loadScript(TELE_PATH .. "iNav", "bt")(zone, options)
   end
end)

-- Run once at the creation of the widget
local function create(zone, options)
   local success, result = pcall(function()
      local iNav = loadScript(TELE_PATH .. "iNav", "bt")(zone, options)
      iNav.background()
      return iNav
   end)
   if not success then
      print("iNav Widget Error: " .. tostring(result))
      return {
         update = function() end,
         run = function(event, touchState)
            lcd.drawText(10, 10, "iNav Error:", SMLSIZE)
            lcd.drawText(10, 30, tostring(result), SMLSIZE)
         end,
         background = function() end
      }
   end
   return result
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
