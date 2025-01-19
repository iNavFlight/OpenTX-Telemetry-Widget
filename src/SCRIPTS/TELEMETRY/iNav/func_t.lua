local config, data, modes, dir, SMLCD, FILE_PATH, text, line, rect, fill, frmt = ...


data.TextColor = 0
data.WarningColor = WARNING_COLOR
function data.set_flags(flag, color)
   return flag
end

local function getElrsRFMD(index,version)
   local v2={25,50,100,150,200,250,500,1000}
   local v3={25,50,100,100,150,200,250,333,500,250,500,500,1000}
   local rfmdhz =  version == 3 and v3[index] or version == 2 and v2[index]
   return  rfmdhz or "--"
end

local function title()
	fill(0, 0, LCD_W, 8, FORCE)
	text(0, 0, model.getInfo().name, INVERS)
	if data.doLogs and data.time ~= nil then
		text(SMLCD and 50 or 145, 1, data.time, SMLSIZE + 3)
		line(SMLCD and 50 or 145, 7, SMLCD and 83 or 178, 7, SOLID, FORCE)
	elseif config[13].v > 0 then
		lcd.drawTimer(SMLCD and 60 or 150, 1, data.timer, SMLSIZE + INVERS)
	end
	if config[19].v > 0 then
		fill(86, 1, 19, 6, ERASE)
		line(105, 2, 105, 5, SOLID, ERASE)
		tmp = math.max(math.min((data.txBatt - data.txBattMin) / (data.txBattMax - data.txBattMin) * 17, 17), 0) + 86
		for i = 87, tmp, 2 do
			line(i, 2, i, 5, SOLID, FORCE)
		end
	end
	if config[19].v ~= 1 then
		text(SMLCD and ((config[14].v == 1 or data.crsf) and 105 or LCD_W) or 128, 1, frmt("%.1fV", data.txBatt), SMLSIZE + RIGHT + INVERS)
	end
	if data.rxBatt > 0 and data.telem and config[14].v == 1 then
		text(LCD_W, 1, frmt("%.1fV", data.rxBatt), SMLSIZE + RIGHT + INVERS)
	elseif data.crsf then
	   if data.elrs > 0 then
	      local ermfd = getElrsRFMD(data.rfmd, data.elrs)
	      text(LCD_W, 1, ermfd .. (SMLCD and "" or "Hz"), SMLSIZE + RIGHT + INVERS)
	   else
	      text(LCD_W, 1, (data.rfmd == 2 and 150 or (data.telem and 50 or "--")) .. (SMLCD and "" or "Hz"), SMLSIZE + RIGHT + INVERS)
	   end
	end

	--[[ Show FPS - Should always be 20fps on Taranis
	data.frames = data.frames + 1
	text(SMLCD and 57 or 80, 1, frmt("%.1f", data.frames / (getTime() - data.fpsStart) * 100), SMLSIZE + RIGHT + INVERS)
	]]

	--[[ Show usage
	text(SMLCD and 57 or 80, 1, getUsage() .. "%", SMLSIZE + RIGHT + INVERS)
	]]
end

local function gpsDegMin(c, lat)
   local DEGSYM = data.etx and "°" or "@"
   local gpsD = math.floor(math.abs(c))
   return gpsD .. frmt(DEGSYM .. "%05.2f", (math.abs(c) - gpsD) * 60) .. (lat and (c >= 0 and dir[0] or dir[4]) or (c >= 0 and dir[2] or dir[6]))
end

local function hdopGraph(x, y, s, SMLCD)
	local tmp = ((data.armed or data.modeId == 6) and data.hdop < 11 - config[21].v * 2) or not data.telem
	if config[22].v == 0 then
		if tmp then
			text(x, y, "    ", SMLSIZE + 3)
		end
		for i = 4, 9 do
			line(x - 8 + (i * 2), (data.hdop >= i or not SMLCD) and y + 8 - i or y + 5, x - 8 + (i * 2), y + 5, SOLID, (data.hdop >= i or SMLCD) and 0 or GREY_DEFAULT)
		end
	else
		text(x + 12, s == SMLSIZE and y or y - 2, (data.hdop == 0 and not data.gpsFix) and "--" or (9 - data.hdop) * 0.5 + 0.8, s + RIGHT + (tmp and 3 or 0))
	end
end

local icons = {}

function icons.gps(x, y)
	line(x + 1, y, x + 5, y + 4, SOLID, 0)
	line(x + 1, y + 1, x + 4, y + 4, SOLID, 0)
	line(x + 1, y + 2, x + 3, y + 4, SOLID, 0)
	line(x, y + 5, x + 2, y + 5, SOLID, 0)
	lcd.drawPoint(x + 4, y + 1)
	lcd.drawPoint(x + 1, y + 4)
end

function icons.lock(x, y)
	rect(x, y + 2, 5, 4, 0)
	rect(x + 1, y, 3, 5, FORCE)
end

function icons.home(x, y)
	lcd.drawPoint(x + 3, y - 1)
	line(x + 2, y, x + 4, y, SOLID, 0)
	line(x + 1, y + 1, x + 5, y + 1, SOLID, 0)
	line(x, y + 2, x + 6, y + 2, SOLID, 0)
	line(x + 1, y + 3, x + 1, y + 5, SOLID, 0)
	line(x + 5, y + 3, x + 5, y + 5, SOLID, 0)
	line(x + 2, y + 5, x + 4, y + 5, SOLID, 0)
	lcd.drawPoint(x + 3, y + 4)
end

return title, gpsDegMin, hdopGraph, icons, rect
