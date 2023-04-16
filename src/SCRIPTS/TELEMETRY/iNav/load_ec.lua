-- Log loader for EdgeTX, Colour radios
-- Not used on B&W radios due to missing table APIs

local config, data, FILE_PATH = ...

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
if tempi > 0 then
   table.sort( tempf )
   for i = #tempf, 1, -1 do
      config[34].x = config[34].x + 1
      config[34].l[config[34].x] = tempf[i]
      collectgarbage()
      if config[34].x == 5 then break end
   end
end
collectgarbage()
return
