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

--[[
local function debug_devinfo(data)
   local ut = getRtcTime()
   local s = string.format("/LOGS/E_%d.txt", ut)
   local fh = io.open(s,"wb")
   dbg_serialize(fh, data)
   io.close(fh)
end

local function dbg_serialize (fh, o)
   if type(o) == "number" then
      io.write(fh, o)
   elseif type(o) == "string" then
      io.write(fh, string.format("%q", o))
   elseif type(o) == "table" then
      io.write(fh, "{\n")
      for k,v in pairs(o) do
	 io.write(fh, "  [")
	 dbg_serialize(fh, k)
	 io.write(fh, "] = ")
	 dbg_serialize(fh, v)
	 io.write(fh, ",\n")
      end
      io.write(fh, "}\n")
   else
      print("cannot serialize a " .. type(o))
   end
end
--]]

--  See https://github.com/iNavFlight/OpenTX-Telemetry-Widget/issues/70#issuecomment-1383190840
--  For annotation

local function parseDeviceInfoMessage(data)
   local offset
   local id = data[2]
   local devicesName
   local majId = -1
   devicesName, offset = fieldGetString(data, 3)
   if deviceId == id then
      -- debug_devinfo(data)
      if ((fieldGetValue(data,offset,4) == 0x454C5253) and (deviceId == 0xEE)) then
	 majId = data[offset+9]
      end
   end
   return majId
end

-- Returns 1/2/3 if ELRS (ELRS Major version), -1 if TBS, and 0 if unknown
local function elrs()
   -- the request for data has already been sent
   local command, data = crossfireTelemetryPop()
   if command == 0x29 then
      return parseDeviceInfoMessage(data)
   end
   return 0
end

return elrs
