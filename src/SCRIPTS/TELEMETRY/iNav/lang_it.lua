local modes, labels = ...

-- Max 7 characters
--modes[1].t  = "! TELEM !"	-- ! TELEM !
--modes[2].t  = "HORIZON"	-- HORIZON
--modes[3].t  = "  ANGLE"	-- ANGLE
--modes[4].t  = "   ACRO"	-- ACRO
modes[5].t  = " NON OK"		-- NOT OK
modes[6].t  = " PRONTO"		-- READY
--modes[7].t  = "POS HOLD"	-- POS HOLD
--modes[8].t  = "WAYPOINT"	-- WAYPOINT
modes[9].t  = "MANUALE"		-- MANUAL
--modes[10].t = "   RTH   "	-- RTH
--modes[11].t = "! FAIL !"	-- ! FAIL !
modes[12].t = "! GAS !"		-- ! THROT !
--modes[13].t = " CRUISE"	-- CRUISE

-- Max 10 characters
labels[1] = "Carburante"	-- Fuel
labels[2] = "Batteria"		-- Battery
labels[3] = "Corrente"		-- Current
labels[4] = "Altitudine"	-- Altitude
labels[5] = "Distanza"		-- Distance

local function lang(config2)
	-- Max 16 characters
	config2[1].t  = "Vista Batteria"	-- Battery View
	config2[2].t  = "Cella Scarica"		-- Cell Low
	config2[3].t  = "Cella Critica"		-- Cell Critical
	config2[4].t  = "Avvisi Vocali"	-- Voice Alerts
	--config2[5].t  = "Feedback"		-- Feedback
	config2[6].t  = "Altezza Max"		-- Max Altitude
	config2[7].t  = "Variometro"		-- Variometer
	--config2[8].t  = "RTH Feedback"	-- RTH Feedback
	--config2[9].t  = "HeadFree Feedback"	-- HeadFree Feedback
	--config2[10].t = "RSSI Feedback"	-- RSSI Feedback
	config2[11].t = "Avvisi Batteria"	-- Battery Alert
	config2[12].t = "Avvisi Altezza"	-- Altitude Alert
	--config2[13].t = "Timer"		-- Timer
	config2[14].t = "Voltaggio Rx"		-- Rx Voltage
	config2[15].t = "Icona casa HUD"	-- HUD Home Icon
	--config2[16].t = "GPS"			-- GPS
	config2[17].t = "CarburanteCritico"	-- Fuel Critical
	config2[18].t = "Carburante Basso"	-- Fuel Low
	config2[19].t = "Voltaggio Tx"		-- Tx Voltage
	config2[20].t = "Sensore Velocità"	-- Speed Sensor
	config2[21].t = "Avviso GPS"		-- GPS Warning
	config2[22].t = "Vista GPS HDOP"	-- GPS HDOP View
	config2[23].t = "Unità Carburante"	-- Fuel Unit
	--config2[24].t = "Vario Steps"		-- Vario Steps
	config2[25].t = "Modalità Vista"	-- View Mode
	--config2[26].t = "AltHold Center FB"	-- AltHold Center FB
	config2[27].t = "Capacità Batteria"	-- Battery Capacity
	config2[28].t = "Grafico Altezza"	-- Altitude Graph
	config2[29].t = "Calcolo Celle"		-- Cell Calculation - TODO: forse "stima"
	config2[30].t = "Simbolo Aereo"		-- Aircraft Symbol
	--config2[31].t = "Centra mappa"	-- Center Map Home - TODO
	config2[32].t = "Orientamento"		-- Orientation
	--config2[33].t = "Roll Scale"		-- Roll Scale
	--config2[34].t = "Playback Log"	-- Playback Log

	-- Max 8 characters
	config2[1].l =  {[0] = "Cella", "Totale"}			-- "Cell", "Total"
	config2[4].l =  {[0] = "Off", "Critico", "Tutti"}		-- "Off", "Critical", "All"
	config2[5].l =  {[0] = "Off", "Vibra", "Beep", "Entrambi"}	-- "Off", "Haptic", "Beeper", "All"
	config2[7].l =  {[0] = "Off", "Grafico", "Voce", "Entrambi"}	-- "Off", "Graph", "Voice", "Both"
	--config2[8].l =  {[0] = "Off", "On"}				-- "Off", "On"
	--config2[9].l =  {[0] = "Off", "On"}				-- "Off", "On"
	--config2[10].l = {[0] = "Off", "On"}				-- "Off", "On"
	config2[11].l = {[0] = "Off", "Critico", "Tutti"}		-- "Off", "Critical", "All"
	--config2[12].l = {[0] = "Off", "On"}				-- "Off", "On"
	--config2[13].l = {[0] = "Off", "Auto", "1", "2"}		-- "Off", "Auto", "1", "2"
	--config2[14].l = {[0] = "Off", "On"}				-- "Off", "On"
	config2[16].l = {[0] = "Decimale", "Gradi"}			-- "Decimal", "Deg/Min"
	config2[19].l = {[0] = "Numerico", "Grafico", "Entrambi"}	-- "Number", "Graph", "Both"
	--config2[20].l = {[0] = "GPS", "Pitot"}			-- "GPS", "Pitot"
	config2[22].l = {[0] = "Grafico", "Decimal"}			-- "Graph", "Decimal"
	--config2[23].l = {[0] = "Percent", "mAh", "mWh"}		-- "Percent", "mAh", "mWh"
	config2[25].l = {[0] = "Clasica", "Pilot", "Radar", "Altezza"}	-- "Classic", "Pilot", "Radar", "Altitude"
	--config2[26].l = {[0] = "Off", "On"}				-- "Off", "On"
	--config2[28].l[0] = "Off"					-- "Off"
	--config2[31].l = {[0] = "Off", "On"}				-- "Off", "On"
	config2[32].l = {[0] = "Lancia", "Bussola"}			-- "Launch", "Compass"
	--config2[33].l = {[0] = "Off", "On"}				-- "Off", "On"

	return {[0] = "Off", "On"}	-- "Off", "On"
end

return lang
