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

local log = getDateTime()
config[34].x = -1

-- From EdgeTX 2.7.1 (at least) we don't need to translate spaces
local mbase = model.getInfo().name .. "-20"
local mblen = string.len(mbase)
local tempf = {}
local tempi = 0
for fname in  dir("/LOGS") do
   if string.find(fname, mbase, 1, true) == 1 then
      local dstr = string.sub(fname, mblen+1, -5)
      local lyr = tonumber(string.sub(dstr, 1, 2))+2000
      local lmo = tonumber(string.sub(dstr, 4, 5))
      local lda = tonumber(string.sub(dstr, 7, 8))
      tdiff = 366*(log.year-lyr) + (log.mon-lmo)*31 + log.day - lda
      if tdiff < 16 then
	 tempi = tempi + 1
	 tempf[tempi] = dstr
      end
   end
end
table.sort( tempf )
for i = #tempf, 1, -1 do
   config[34].x = config[34].x + 1
   config[34].l[config[34].x] = tempf[i]
   collectgarbage()
   if config[34].x == 5 then break end
end
collectgarbage()
return
