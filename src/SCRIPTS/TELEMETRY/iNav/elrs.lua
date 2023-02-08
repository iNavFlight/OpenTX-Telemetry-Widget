-- Adapted from ELRSv2.lua in ExpressLRS

local function fieldStrFF(data, offset)
  while data[offset] ~= 0 do
    offset = offset + 1
  end
  return offset + 1
end

local function fieldGetValue(data, offset, size)
   local result = 0
   for i=0, size-1 do
      result = bit32.lshift(result, 8) + data[offset + i]
   end
   return result
end

--  See https://github.com/ExpressLRS/ExpressLRS/wiki/CRSF-Protocol#device-info--device-ping-response-0x29
--  For annotation
local function parseDeviceInfoMessage(data)
   local majId = -1
   local deviceId = data[2]
   local offset = fieldStrFF(data, 3)
   if deviceId == 0xEE then -- TX device
      -- debug_devinfo(data)
      if fieldGetValue(data,offset,4) == 0x454C5253 then -- 'ELRS'
        majId = data[offset+9]
        if majId == 0 then
          majId = 2 -- v2 did not report version, v1 didn't support this protocol
        end
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
