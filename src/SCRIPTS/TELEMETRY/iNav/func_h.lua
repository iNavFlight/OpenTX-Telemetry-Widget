local config, data, modes, dir, SMLCD, FILE_PATH, text, line, rect, fill, frmt, opts = ...

local OYELLOW = data.RGB(255, 220, 16) -- common across ETX/OTX
local DEGSYM = data.etx and "°" or "@"

data.TextColor = opts.Text
data.WarningColor = opts.Warn

function data.set_flags(flag, color)
   local rflag
   if data.etx then
      rflag  = bit32.bor(flag, color) -- flag + color
   else
      lcd.setColor(CUSTOM_COLOR, color)
      rflag = bit32.bor(flag, CUSTOM_COLOR) -- flag + CUSTOM_COLOR
   end
   return rflag
end

local function getElrsRFMD(index,version)
   local v2={25,50,100,150,200,250,500,1000}
   local v3={25,50,100,100,150,200,250,333,500,250,500,500,1000}
   local rfmdhz = version == 3 and v3[index] or version == 2 and v2[index]
--   print("DBG: ELRS", index, "version", version, "val", rfmdhz)
   return  rfmdhz or "--"
end

local function title()
	local color = lcd.setColor
	local tmp = data.TextColor
	local flags = 0

	if not data.telem then
	   tmp = data.WarningColor
	end

	-- Title
	fill(0, 0, LCD_W, 20, data.set_flags(0,BLACK))

	-- Model
	text(0, 0, model.getInfo().name, data.set_flags(0, data.TextColor))

	-- TX battery
	local bat = data.nv and 135 or 197
	if config[19].v > 0 then
	   flags = data.set_flags(0, data.TextColor)
	   fill(bat, 3, 43, 14, flags)
	   fill(bat + 43, 6, 2, 8, flags)
	   local lev = math.max(math.min((data.txBatt - data.txBattMin) / (data.txBattMax - data.txBattMin) * 42, 42), 0) + bat
	   for i = bat + 3, lev, 4 do
	      fill(i, 5, 2, 10, data.set_flags(0,BLACK))
	   end
	end
	if config[19].v ~= 1 then
	   text(data.nv and 180 or bat + 93, 0, frmt("%.1fV", data.txBatt), data.set_flags(RIGHT, data.TextColor))
	end

	-- Timer
	if config[13].v > 0 then
		if data.doLogs and data.time ~= nil then
		   text(data.nv and 184 or 340, 0, data.time, data.set_flags(0, data.TextColor))
		else
		   lcd.drawTimer(data.nv and 202 or 340, 0, data.timer, data.set_flags(0,data.TextColor))
		end
	end

	-- Receiver voltage or Crossfire speed
	if data.rxBatt > 0 and config[14].v == 1 then
	   text(LCD_W, 0, frmt("%.1fV", data.rxBatt), data.set_flags(RIGHT, tmp))
	elseif data.crsf then
	   if data.elrs > 0 then
--	      print("DBG: data.rfmd", data.rfmd, "id", data.rfmd_id)
	      local ermfd = getElrsRFMD(data.rfmd, data.elrs)
	      text(LCD_W, 0, ermfd .. "Hz", data.set_flags(RIGHT, tmp))
	   else
	      text(LCD_W, 0, (data.rfmd == 2 and 150 or (data.telem and 50 or "--")) .. "Hz", data.set_flags(RIGHT,tmp))
	   end
	end

	-- Data on config menu
	if data.configStatus > 0 then
	   local dkgrey = data.RGB(49, 48, 49)
	   fill(0, 30, 75, (22 * (data.crsf and 1 or 2)) + 14, data.set_flags(0, dkgrey))
	   flags = data.set_flags(0, data.TextColor)
	   rect(0, 30, 75, (22 * (data.crsf and 1 or 2)) + 14, flags)
	   text(4, 37, "Sats:", flags)
	   text(72, 37, data.satellites % 100, data.set_flags(RIGHT, tmp))
	   if not data.crsf then
	      text(4, 59, "DOP:", data.set_flags(0, data.TextColor))
	      text(72, 59, (data.hdop == 0 and not data.gpsFix) and "---" or (9 - data.hdop) * 0.5 + 0.8, data.set_flags(RIGHT, tmp))
	   end
	end

	--[[ Show FPS ]]
	if data.nv then
		data.frames = data.frames + 1
		--text(data.nv and 75 or 130, 0, frmt("%.1f", math.min(100 / (getTime() - data.start), 20)), RIGHT)
		text(data.nv and 115 or 180, 0, frmt("%.1f", data.frames / (getTime() - data.fpsStart) * 100), data.set_flags(RIGHT,data.TextColor))
	end

end

local function gpsDegMin(c, lat)
	local gpsD = math.floor(math.abs(c))
	local gpsM = math.floor((math.abs(c) - gpsD) * 60)
	return frmt(data.nv and "%d"..DEGSYM.."%d'%04.1f\"" or "%d"..DEGSYM.."%d'%05.2f\"", gpsD, gpsM, ((math.abs(c) - gpsD) * 60 - gpsM) * 60) .. (lat and (c >= 0 and dir[0] or dir[4]) or (c >= 0 and dir[2] or dir[6]))
end

local function hdopGraph(x, y)
	local ctmp = data.hdop < 11 - config[21].v * 2 and OYELLOW or WHITE
	for i = 4, 9 do
		if i > data.hdop then
		   ctmp = data.RGB(131, 137, 148)
		end
		fill(i * 4 + x - 16, y - (i * 3 - 10), 2, i * 3 - 10, data.set_flags(0, ctmp))
	end
end

local icons = {}
icons.lock = Bitmap.open(FILE_PATH .. "pics/lock.png")
icons.home = {
	[0] = Bitmap.open(FILE_PATH .. "pics/homes.png"),
	[1] = Bitmap.open(FILE_PATH .. "pics/homem.png"),
	[2] = Bitmap.open(FILE_PATH .. "pics/homel.png"),
}
icons.fpv = Bitmap.open(FILE_PATH .. "pics/fpv.png")
icons.bg = Bitmap.open(FILE_PATH .. (data.nv and "pics/bgnv.png" or "pics/bg.png"))
icons.roll = Bitmap.open(FILE_PATH .. "pics/roll.png")
icons.fg = Bitmap.open(FILE_PATH .. "pics/fg" .. config[30].v .. ".png")

data.hcurx_id = getFieldInfo("ail").id
data.hcury_id = getFieldInfo("ele").id
data.hctrl_id = getFieldInfo("rud").id
data.t6_id = getFieldInfo("trim-t6") ~= nil and getFieldInfo("trim-t6").id or nil
data.lastevt = 0
data.lastt6 = nil

-- Remove spaces from front of modes to center
for i = 1, #modes do
	if modes[i].f == 0 then
		while string.sub(modes[i].t, 1, 1) == " " do
			modes[i].t = string.sub(modes[i].t, 2)
		end
	end
end
modes[4].t = "ACRO"

-- Make sure widget is full screen
if type(iNavZone) == "table" and type(iNavZone.zone) ~= "nil" then
	data.widget = true
	if iNavZone.zone.w < (data.nv and 280 or 450) or iNavZone.zone.h < (data.nv and 450 or 250) then
		data.startupTime = math.huge
		function data.nfs()
		   text(iNavZone.zone.x + 14, iNavZone.zone.y + 16, "Full screen required", data.set_flags(SMLSIZE, data.WarningColor))
		end
	end
end

-- Nirvana's drawRectangle function is broken, replace it
if data.nv then
	function rect(x, y, w, h, color)
		w = w - 1
		h = h - 1
		line(x, y, x + w, y, SOLID, color)
		line(x + w, y, x + w, y + h, SOLID, color)
		line(x + w, y + h, x, y + h, SOLID, color)
		line(x, y + h, x, y, SOLID, color)
	end
end

function data.clear(event)
   local bcol = data.nv and (data.configStatus > 0 and data.RGB(98, 106, 115) or data.RGB(50, 82, 115)) or data.RGB(0, 32, 65)
   lcd.clear(data.set_flags(0, bcol))
   data.WarningColor = data.telem and (data.nv and data.RGB(255, 255, 100) or OYELLOW) or (data.nv and data.RGB(255, 100, 100) or RED) --lcd.RGB(255, 255, 100) / lcd.RGB(255, 100, 100)

	if event == 0 or event == nil then
		event = 0
		if not data.armed then
			data.stickMsg = (data.throttle >= -940 or math.abs(getValue(data.hctrl_id)) >= 50) and "Return throttle stick to bottom center" or nil
			if data.throttle > 940 and getValue(data.hctrl_id) > 940 and math.abs(getValue(data.hcurx_id)) < 50 and math.abs(getValue(data.hcury_id)) < 50 then
				event = EVT_SYS_FIRST -- Enter config menu
			elseif data.stickMsg == nil then
				if getValue(data.hcurx_id) < -940 then
					event = EVT_EXIT_BREAK -- Left (exit)
				elseif getValue(data.hcurx_id) > 940 then
					event = EVT_ENTER_BREAK -- Right (enter)
				elseif getValue(data.hcury_id) > 200 then
					event = data.nv and EVT_VIRTUAL_PREV or EVT_ROT_LEFT -- Up
				elseif getValue(data.hcury_id) < -200 then
				   event = data.nv and EVT_VIRTUAL_NEXT or EVT_ROT_RIGHT -- Down
				end
			end
			if data.lastevt == event and (data.configStatus == 0 or math.abs(getValue(data.hcury_id)) < 940) then
				event = 0
			else
				data.lastevt = event
			end
		end
		if event == 0 and data.lastt6 ~= nil then
			if getValue(data.t6_id) > data.lastt6 then
				event = data.nv and EVT_VIRTUAL_PREV or EVT_ROT_LEFT -- Up
			elseif getValue(data.t6_id) < data.lastt6 then
				event = data.nv and EVT_VIRTUAL_NEXT or EVT_ROT_RIGHT -- Down
			end
		end
		if event == 0 and data.doLogs and getValue(data.hcurx_id) < -940 then
			event = EVT_EXIT_BREAK -- Left (exit)
		end
		data.lastt6 = not data.nv and getValue(data.t6_id) or nil
		if data.lastt6 == 0 then
			data.lastt6 = nil
		end
	end
	return event
end

function data.menu(prev)
	if config[30].v ~= prev then
		icons.fg = Bitmap.open(FILE_PATH .. "pics/fg" .. config[30].v .. ".png")
	end

	-- Aircraft symbol preview
	if data.configStatus == 27 and data.configSelect ~= 0 then
	   local scol = data.nv and data.RGB(49, 170, 230) or data.RGB(0, 121, 180)
	   fill(LCD_W - 124, (data.nv and 28 or 111), 123, 31, data.set_flags(0, scol))
	   local gcol = data.nv and data.RGB(148, 117, 57) or data.RGB(98, 68, 8)
	   fill(LCD_W - 124, (data.nv and 59 or 142), 123, 31, data.set_flags(0, gcol))
	   lcd.drawBitmap(icons.fg, LCD_W - 125, (data.nv and 27 or 110), 50)
	   rect(LCD_W - 125, (data.nv and 27 or 110), 125, 64, data.set_flags(0,data.TextColor))
	end
	-- Return throttle stick to bottom center
	if data.stickMsg ~= nil and not data.armed then
	   local tflags = data.set_flags(data.nv and SMLSIZE or MIDSIZE, OYELLOW)
	   local ox,oy, oh, ow, ty
	   if data.etx then -- takes flags into account for sizing
	      fw,fh = lcd.sizeText(data.stickMsg, tflags)
	      oh = fh + 2
	      ow = fw + 16
	      ox = (LCD_W - ow) / 2 - 1
	      oy = (LCD_H - fh) / 2 - 2
	      ty = oy + 1
	   else
	      if data.nv then
		 ox = 6
		 oy = 270
		 ow = 308
		 ty = 275
	      else
		 ox = 20
		 oy = 128
		 ow = 439
		 ty = 128
	      end
	      oh = 30
	   end
	   fill(ox, oy, ow, oh, data.set_flags(0, BLACK))
	   rect(ox-1, oy - 1, ow+2, oh + 2, data.set_flags(0, OYELLOW))
	   text(ox+8, ty, data.stickMsg, tflags)
	end
end

return title, gpsDegMin, hdopGraph, icons, rect
