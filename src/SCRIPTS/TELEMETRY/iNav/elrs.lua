-- Adapted from ELRSv2.lua in ExpressLRS

local deviceId = 0xEE

local function byteToStr(b)
	-- Translate b into a string from symbolChars if available, else use string.char
	return symbolChars and symbolChars[b] or string.char(b)
end

local function fieldGetString(data, offset, last)
	if last then
		return fieldStrFF(data, offset, last)
	end

	local result = ""
	while data[offset] ~= 0 do
		result = result .. byteToStr(data[offset])
		offset = offset + 1
	end

	return result, offset + 1
end

local function fieldGetValue(data, offset, size)
	local result = 0
	for i=0, size-1 do
		result = bit32.lshift(result, 8) + data[offset + i]
	end
	return result
end

local function parseDeviceInfoMessage(data)
	local offset
	local id = data[2]
	local devicesName
	devicesName, offset = fieldGetString(data, 3)
	if deviceId == id then
		deviceIsELRS_TX = ((fieldGetValue(data,offset,4) == 0x454C5253) and (deviceId == 0xEE)) or nil -- SerialNumber = 'E L R S' and ID is TX module
		return deviceIsELRS_TX
	end
end

-- Returns 1 if elrs, -1 if TBS, and 0 if unknown
local function elrs()
	-- the request for data has already been sent
	local command, data = crossfireTelemetryPop()
	if command == 0x29 then
		if parseDeviceInfoMessage(data) then
			return 1
		end
		return -1
	end
	return 0
end

return elrs
