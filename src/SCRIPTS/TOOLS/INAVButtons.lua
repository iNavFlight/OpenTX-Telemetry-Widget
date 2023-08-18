
local last_event = 0
local ecount = 0
local sz
local nl
local lh
local lastl = 0
local lines = {}
local verbose = false

-- Change `ALWAYS = true` in order to see non-virtual events
local ALWAYS = false

local function report(event)
   local txt=""
   local matched = true
   if event == EVT_EXIT_BREAK then txt = "EVT_EXIT_BREAK"
   elseif event == EVT_MENU_BREAK then txt = "EVT_MENU_BREAK"
   elseif event == EVT_PAGE_BREAK then txt = "EVT_PAGE_BREAK"
   elseif event == EVT_PAGE_LONG then txt = "EVT_PAGE_LONG"
   elseif event == EVT_ENTER_BREAK then txt = "EVT_ENTER_BREAK"
   elseif event == EVT_ENTER_LONG then txt = "EVT_ENTER_LONG"
   elseif event == EVT_PLUS_BREAK then txt = "EVT_PLUS_BREAK"
   elseif event == EVT_MINUS_BREAK then txt = "EVT_MINUS_BREAK"
   elseif event == EVT_PLUS_FIRST then txt = "EVT_PLUS_FIRST"
   elseif event == EVT_MINUS_FIRST then txt = "EVT_MINUS_FIRST"
   elseif event == EVT_PLUS_REPT then txt = "EVT_PLUS_REPT"
   elseif event == EVT_MINUS_REPT then txt = "EVT_MINUS_REPT"
   elseif event == EVT_ROT_BREAK then txt = "EVT_ROT_BREAK"
   elseif event == EVT_ROT_LONG then txt = "EVT_ROT_LONG"
   elseif event == EVT_ROT_LEFT then txt = "EVT_ROT_LEFT"
   elseif event == EVT_ROT_RIGHT then txt = "EVT_ROT_RIGHT"
   elseif event == EVT_VIRTUAL_NEXT_PAGE then txt = "EVT_VIRTUAL_NEXT_PAGE"
   elseif event == EVT_VIRTUAL_PREV_PAGE then txt = "EVT_VIRTUAL_PREV_PAGE"
   elseif event == EVT_VIRTUAL_ENTER then txt = "EVT_VIRTUAL_ENTER"
   elseif event == EVT_VIRTUAL_ENTER_LONG then txt = "EVT_VIRTUAL_ENTER_LONG"
   elseif event == EVT_VIRTUAL_MENU then txt = "EVT_VIRTUAL_MENU"
   elseif event == EVT_VIRTUAL_MENU_LONG then txt = "EVT_VIRTUAL_MENU_LONG"
   elseif event == EVT_VIRTUAL_NEXT then txt = "EVT_VIRTUAL_NEXT"
   elseif event == EVT_VIRTUAL_NEXT_REPT then txt = "EVT_VIRTUAL_NEXT_REPT"
   elseif event == EVT_VIRTUAL_PREV then txt = "EVT_VIRTUAL_PREV"
   elseif event == EVT_VIRTUAL_PREV_REPT then txt = "EVT_VIRTUAL_PREV_REPT"
   elseif event == EVT_VIRTUAL_INC then txt = "EVT_VIRTUAL_INC"
   elseif event == EVT_VIRTUAL_INC_REPT then txt = "EVT_VIRTUAL_INC_REPT"
   elseif event == EVT_VIRTUAL_DEC then txt = "EVT_VIRTUAL_DEC"
   elseif event == EVT_VIRTUAL_DEC_REPT then txt = "EVT_VIRTUAL_DEC_REPT"
   else
      txt = "Event: "..event
      matched = false
   end
   return txt,matched
end

function run (event, touchState)
   lcd.clear()
   if verbose then
      print("evt "..event.." last "..last_event.." lastl="..lastl.." nl="..nl)
   end

   if (event == 0 or event == 0xdd00) and last_event == 0  then
      lcd.drawText(3, 2, "Button Test", MIDSIZE)
      lcd.drawText(3, 24, "Long RTN to exit")
      lcd.drawText(3, 48, "Ready for button presses...", SMLSIZE)
   else
      if event ~= 0 then
	 last_event = event
	 local str,ok = report(last_event)
	 if ok or always then
	    if lastl < nl then
	       lines[lastl] = str
	       lastl = lastl + 1
	    else
	       for j = 0, nl-2, 1 do
		     lines[j] = lines[j+1]
	       end
	       lines[nl -1] = str
	    end
	 end
      end
      for j = 0, lastl-1, 1 do
	 lcd.drawText(2, j*lh, lines[j], sz)
      end
   end
   ecount =  ecount + 1
   return 0
end

local function init()
   if LCD_W >= 480 or LCD_H >= 480 then
      local v, r, m, i, e, osname = getVersion()
      sz = 0
      if osname ~= nil and osname == "EdgeTX" and (m > 2 or i > 4) then
	 local w
	 w,lh = lcd.sizeText("EVT", sz)
      else
	 lh = 21 --regardless
      end
   else
      sz = SMLSIZE
      lh = 8
   end
   nl = math.floor(LCD_H / lh)
   if verbose then
      print("H="..LCD_H.." lh = "..lh.." nl = "..nl)
   end
end

return {
   run = run,
   init = init
}
