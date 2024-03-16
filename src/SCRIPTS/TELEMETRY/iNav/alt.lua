local function view(data, config, modes, dir, units, labels, gpsDegMin, hdopGraph, icons, calcBearing, calcDir, VERSION, SMLCD, FILE_PATH, text, line, rect, fill, frmt)
	local LEFT_DIV = 36
	local LEFT_POS = SMLCD and LEFT_DIV or 73
	local RIGHT_POS = SMLCD and LCD_W - 31 or LCD_W - 53
	local X_CNTR = (RIGHT_POS + LEFT_POS) * 0.5 - 1
	local FLASH =  3 -- legacy value
	local gpsFlags = SMLSIZE + RIGHT + ((not data.telem or not data.gpsFix) and FLASH or 0)
	local tmp, pitch

	-- Startup message
	if data.startup == 2 then
		if not SMLCD then
			text(LEFT_POS + 8, 28, "Lua Telemetry")
		end
		text(X_CNTR - 10, SMLCD and 29 or 40, "v" .. VERSION)
	end

	-- Flight modes
	tmp = X_CNTR - (SMLCD and 16 or 19)
	text(tmp + 1, 9, modes[data.modeId].t, SMLSIZE + modes[data.modeId].f)
	if data.headFree then
		text(tmp, 9, "HF", SMLSIZE + FLASH + RIGHT)
	end

	-- Pitch calculation
	if data.pitchRoll then
		pitch = ((math.abs(data.roll) > 900 and -1 or 1) * (270 - data.pitch * 0.1) % 180) - 90
	else
		pitch = math.deg(math.atan2(data.accx * (data.accz >= 0 and -1 or 1), math.sqrt(data.accy * data.accy + data.accz * data.accz))) * -1
	end
	pitch = pitch >= 0 and (pitch < 1 and 0 or math.floor(pitch + 0.5)) or (pitch > -1 and 0 or math.ceil(pitch - 0.5))

	local telemFlag = data.telem and 0 or FLASH
	-- Bottom center
	if SMLCD then
		if data.showDir then
			-- GPS coords
			text(RIGHT_POS, 49, config[16].v == 0 and frmt("%.5f", data.gpsLatLon.lat) or gpsDegMin(data.gpsLatLon.lat, true), gpsFlags)
			text(RIGHT_POS, 57, config[16].v == 0 and frmt("%.5f", data.gpsLatLon.lon) or gpsDegMin(data.gpsLatLon.lon, false), gpsFlags)
		else
			line(LEFT_POS + 31, 48, LEFT_POS + 31, 63, SOLID, FORCE)
			-- Distance
			tmp = data.showMax and data.distanceMax or data.distanceLast
			text(LEFT_POS + 29, 57, tmp < 1000 and math.floor(tmp + 0.5) .. units[data.dist_unit] or (frmt("%.1f", tmp / (data.dist_unit == 9 and 1000 or 5280)) .. (data.dist_unit == 9 and "km" or "mi")), SMLSIZE + RIGHT + telemFlag)
			text(LEFT_POS + 10, 49, "Dist", SMLSIZE)
			icons.home(LEFT_POS + 2, 49)
			-- Altitude
			tmp = data.showMax and data.altitudeMax or data.altitude
			text(RIGHT_POS, 57, math.floor(tmp + 0.5) .. units[data.alt_unit], SMLSIZE + RIGHT + ((not data.telem or tmp + 0.5 >= config[6].v) and FLASH or 0))
			text(RIGHT_POS, 49, "Alt", SMLSIZE + RIGHT)
			if data.altHold then
				icons.lock(RIGHT_POS - 20, 49)
			end
		end
	end
	-- Min/Max
	if not data.showDir and data.showMax then
		text(RIGHT_POS, 9, "\192", SMLSIZE + RIGHT)
	end

	if data.startup == 0 then
		-- Altitude graph
		local BOTTOM = SMLCD and 47 or 63
		tmp = (SMLCD and 30 or 40) / (data.altMax - data.altMin)
		line(RIGHT_POS - 60, BOTTOM,  RIGHT_POS - 1, BOTTOM, SOLID, (SMLCD or config[35].v == 1) and FORCE or GREY_DEFAULT + FORCE)
		for i = 1, 60 do
			local cx = RIGHT_POS - 61 + i
			local cy = math.floor(BOTTOM - (data.alt[((data.altCur - 2 + i) % 60) + 1] - data.altMin) * tmp)
			if cy < BOTTOM then
				line(cx, cy, cx, BOTTOM - 1, SOLID, (SMLCD or config[35].v == 1) and FORCE or GREY_DEFAULT + FORCE)
			end
			if (i ~= 1 or not SMLCD) and (i - 1) % (60 / config[28].v) == 0 then
				line(cx, BOTTOM - (SMLCD and 30 or 40), cx, BOTTOM, DOTTED, 0)
			end
		end
		if data.altMin < -1 then
			local cy = data.altMin * tmp + BOTTOM
			line(RIGHT_POS - 60, cy, RIGHT_POS - 1, cy, DOTTED, 0)
		end
		if not SMLCD then
			text(RIGHT_POS - 60, 19, math.floor(data.altMax + 0.5) .. units[data.alt_unit], SMLSIZE + RIGHT)
		end

		-- Orientation
		if not SMLCD and data.telem then
			if data.showDir or data.headingRef == -1 then
				text(LEFT_POS + 12, 29, dir[0], SMLSIZE)
				text(LEFT_POS + 25 - (data.heading < 100 and 3 or 0) - (data.heading < 10 and 3 or 0), 57, math.floor(data.heading + 0.5) % 360 .. "\64", SMLSIZE + RIGHT + telemFlag)
				tmp = data.heading
			else
				tmp = data.heading - data.headingRef
			end
			local r1 = math.rad(tmp)
			local r2 = math.rad(tmp + 145)
			local r3 = math.rad(tmp - 145)
			local x1, y1, x2, y2, x3, y3 = calcDir(r1, r2, r3, LEFT_POS + 14, 45, 7)
			if data.headingHold then
				fill((x2 + x3) * 0.5 - 1, (y2 + y3) * 0.5 - 1, 3, 3, SOLID)
			else
				line(x2, y2, x3, y3, SMLCD and DOTTED or SOLID, FORCE + ((SMLCD or config[35].v == 1) and 0 or GREY_DEFAULT))
			end
			line(x1, y1, x2, y2, SOLID, FORCE)
			line(x1, y1, x3, y3, SOLID, FORCE)
		end
	end

	-- Variometer
	if config[7].v % 2 == 1 then
		line(RIGHT_POS, 8, RIGHT_POS, 63, SOLID, FORCE)
		line(RIGHT_POS + (SMLCD and 4 or 6), 8, RIGHT_POS + (SMLCD and 4 or 6), 63, SOLID, FORCE)
		line(RIGHT_POS + 1, 35, RIGHT_POS + (SMLCD and 3 or 5), 35, SMLCD and DOTTED or SOLID, (SMLCD or config[35].v == 1) and 0 or GREY_DEFAULT)
		if data.armed then
			tmp = math.log(1 + math.min(math.abs(0.6 * (data.vspeed_unit == 6 and data.vspeed * 0.3048 or data.vspeed)), 10)) * (data.vspeed < 0 and -1 or 1)
			local y1 = 36 - (tmp * 11)
			local y2 = 36 - (tmp * 9)
			line(RIGHT_POS + 1, y1 - 1, RIGHT_POS + (SMLCD and 3 or 5), y2 - 1, SOLID, FORCE)
			line(RIGHT_POS + 1, y1, RIGHT_POS + (SMLCD and 3 or 5), y2, SOLID, FORCE)
		end
	else
		line(RIGHT_POS, 8, RIGHT_POS, 63, SOLID, FORCE)
	end

	-- Right data - GPS
	text(LCD_W, data.crsf and 20 or 8, data.satellites % 100, MIDSIZE + RIGHT + telemFlag)
	icons.gps(LCD_W - (SMLCD and 23 or 22), data.crsf and 24 or 12)
	if data.crsf then
		text(LCD_W, SMLCD and 9 or 11, data.tpwr < 1000 and data.tpwr .. "mW" or data.tpwr * 0.001 .. "W", SMLSIZE + RIGHT + telemFlag)
	else
		text(LCD_W + 1, SMLCD and 43 or 24, math.floor(data.gpsAlt + 0.5) .. units[data.gpsAlt_unit], gpsFlags)
	end
	if SMLCD then
		if data.crsf == false then
			text(LCD_W + 1, config[22].v == 0 and 32 or 22, "HDOP", RIGHT + SMLSIZE)
		end
		hdopGraph(LCD_W - 12, config[22].v == 0 and (data.crsf and 37 or 24) or 31, MIDSIZE, (SMLCD or config[35].v == 1))
	else
		hdopGraph(LCD_W - 39, data.crsf and 24 or 10, MIDSIZE, (SMLCD or config[35].v == 1))
		if data.crsf == false then
			text(LCD_W - (config[22].v == 0 and 24 or 25), config[22].v == 0 and 18 or 20, "HDOP", RIGHT + SMLSIZE)
		end
		text(LCD_W + 1, 33, config[16].v == 0 and frmt("%.5f", data.gpsLatLon.lat) or gpsDegMin(data.gpsLatLon.lat, true), gpsFlags)
		text(LCD_W + 1, 42, config[16].v == 0 and frmt("%.5f", data.gpsLatLon.lon) or gpsDegMin(data.gpsLatLon.lon, false), gpsFlags)
		text(RIGHT_POS + 8, 57, data.crsf and "LQ" or "RSSI", SMLSIZE)
	end
	line(RIGHT_POS + (config[7].v % 2 == 1 and (SMLCD and 5 or 7) or 0), 50, LCD_W, 50, SOLID, FORCE)
	local rssiFlags = RIGHT + ((not data.telem or data.rssi < data.rssiLow) and FLASH or 0)
	text(LCD_W - (data.crsf and 6 or 10), 52, math.min(data.showMax and data.rssiMin or data.rssiLast, data.crsf and 100 or 99), MIDSIZE + rssiFlags)
	text(LCD_W, 57, data.crsf and "%" or "dB", SMLSIZE + rssiFlags)

	-- Left data - Battery
	line(LEFT_DIV, 8, LEFT_DIV, 63, SOLID, FORCE)
	tmp = (not data.telem or data.cell < config[3].v or (data.showFuel and config[23].v == 0 and data.fuel <= config[17].v)) and FLASH or 0
	if data.showFuel then
		if config[23].v > 0 or (data.crsf and data.showMax) then
			text(LEFT_DIV, data.showCurr and 8 or 10, (data.crsf and data.fuelRaw or data.fuel), MIDSIZE + RIGHT + tmp)
			text(LEFT_DIV, data.showCurr and 20 or 23, data.fUnit[data.crsf and 1 or config[23].v], SMLSIZE + RIGHT + tmp)
		else
			text(LEFT_DIV - 5, data.showCurr and 8 or 12, data.fuel, DBLSIZE + RIGHT + tmp)
			text(LEFT_DIV, data.showCurr and 17 or 21, "%", SMLSIZE + RIGHT + tmp)
		end
end
	text(LEFT_DIV - 5, data.showCurr and 25 or 32, frmt(config[1].v == 0 and "%.2f" or "%.1f", config[1].v == 0 and (data.showMax and data.cellMin or data.cell) or (data.showMax and data.battMin or data.batt)), DBLSIZE + RIGHT + tmp)
	text(LEFT_DIV, data.showCurr and 34 or 41, "V", SMLSIZE + RIGHT + tmp)
	if data.showCurr then
		tmp = data.showMax and data.currentMax or data.current
		text(LEFT_DIV - 5, 42, tmp >= 99.5 and math.floor(tmp + 0.5) or frmt("%.1f", tmp), MIDSIZE + RIGHT + telemFlag)
		text(LEFT_DIV, 47, "A", SMLSIZE + RIGHT + telemFlag)
	end
	line(0, data.showCurr and 55 or 53, LEFT_DIV, data.showCurr and 55 or 53, SOLID, FORCE)
	tmp = data.showMax and data.speedMax or data.speed
	text(LEFT_DIV, data.showCurr and 57 or 56, tmp >= 99.5 and math.floor(tmp + 0.5) .. units[data.speed_unit] or frmt("%.1f", tmp) .. units[data.speed_unit], SMLSIZE + RIGHT + telemFlag)

	-- Left data - Wide screen
	if not SMLCD then
		line(LEFT_POS, 8, LEFT_POS, 63, SOLID, FORCE)
		-- Altitude
		tmp = data.showMax and data.altitudeMax or data.altitude
		local tmp2 = data.alt_unit == 9 and 6 or 2
		text(LEFT_DIV + 2, 9, "Alt", SMLSIZE)
		text(LEFT_POS - tmp2, data.alt_unit == 9 and 21 or 17, units[data.alt_unit], SMLSIZE + ((not data.telem or tmp + 0.5 >= config[6].v) and FLASH or 0))
		text(LEFT_POS - tmp2, 16, math.floor(tmp + 0.5), MIDSIZE + RIGHT + ((not data.telem or tmp + 0.5 >= config[6].v) and FLASH or 0))
		if data.altHold then
			icons.lock(LEFT_POS - 6, 9)
		end
		-- Distance
		tmp = data.showMax and data.distanceMax or data.distanceLast
		tmp2 = data.dist_unit == 9 and (tmp < 1000 and 6 or 11) or (tmp < 1000 and 2 or 10)
		text(LEFT_DIV + 2, 30, "Dist", SMLSIZE)
		text(LEFT_POS - tmp2, (data.dist_unit == 9 or tmp >= 1000) and 42 or 38, tmp < 1000 and units[data.dist_unit] or (data.dist_unit == 9 and "km" or "mi"), SMLSIZE + telemFlag)
		text(LEFT_POS - tmp2, 37, tmp < 1000 and math.floor(tmp + 0.5) or frmt("%.1f", tmp / (data.dist_unit == 9 and 1000 or 5280)), MIDSIZE + RIGHT + telemFlag)
		--Pitch
		line(LEFT_DIV, 50, LEFT_POS, 50, SOLID, FORCE)
		text(LEFT_DIV + 5, 54, pitch > 0 and "\194" or (pitch == 0 and "->" or "\195"), SMLSIZE)
		text(LEFT_POS, 53, "\64", SMLSIZE + RIGHT + telemFlag)
		text(LEFT_POS - 4, 52, pitch, MIDSIZE + RIGHT + telemFlag)
	end
end

return view
