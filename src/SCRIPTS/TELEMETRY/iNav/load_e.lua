-- Log loader for EdgeTX

local config, data, FILE_PATH = ...

-- Load config for model
fh = io.open(FILE_PATH .. "cfg/" .. model.getInfo().name .. ".dat")
if fh ~= nil then
   for i = 1, #config do
      local tmp = io.read(fh, config[i].c)
      if tmp ~= "" then
	 config[i].v = config[i].d == nil and math.min(tonumber(tmp), config[i].x == nil and 1 or config[i].x) or tmp * 0.1
      end
   end
   io.close(fh)
end

-- Look for language override
fh = io.open(FILE_PATH .. "cfg/lang.dat")
if fh ~= nil then
   local tmp = io.read(fh, 2)
   io.close(fh)
   data.lang = tmp
   data.voice = tmp
end
return
