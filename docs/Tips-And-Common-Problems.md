## Common Taranis Errors

* Script syntax error
* attempt to call a nil value
* Script panic not enough memory
* Script syntax error not enough memory

#### Solution

* Be sure you're following the [Install/Setup Lua Telemetry on Transmitter](../Getting-Started/#installsetup-lua-telemetry-on-transmitter) instructions
* If you're still getting the above errors, it's probably due to a lack of memory available on your transmitter (very common on Taranis). You can free up memory by removing other Lua Scripts from other screens, deleting unused models or turning off OpenTX firmware build options. Be sure to reboot your controller to free up memory after making a change.

> **NOTE:** If trying to run Betaflight Tx lua script for VTx control, you can't run Betaflight Tx lua script and Lua Telemetry at the same time.  Instead, change VTx settings by using the [OSD menu](https://github.com/iNavFlight/inav/master/docs/Controls.md)

## Common Horus Errors

* **disabled** error on widget
* refresh(): ?:0: attempt to compare number with nil

#### Solution

* Upgrade to the [latest release](../Upgrade) which may fix these issues
* If it doesn't raise a Github issue.

## Tips

* If you have any issues, first make sure you're using a supported version of OpenTX / EdgeTX.
* Preferably use the latest version of your TX firmware (OpenTX or EdgeTX)
* Between flights (before armed), long-press Enter/dial and select `Reset telemetry` to reset telemetry values
* If current sensor isn't present or _battery isn't fully charged when plugged in_, fuel gauge will be based on battery voltage
* If fuel gauge isn't shown or accurate, be sure you've set CLI values `smartport_fuel_unit = percent` and `battery_capacity` correctly. Also, current sensor settings in the configurator need to be calibrated for proper amperage and fuel % data (not applicable to Crossfire)
* If using INAV v2.0.0+ and FrSky telemetry, `set frsky_pitch_roll = ON` in CLI settings and search for new telemetry sensors for accurate attitude display and pitch angle (not applicable to Crossfire)
* Lua Telemetry uses transmitter settings for RSSI warning/critical levels for bar gauge range and audio/haptic warnings
* Lua Telemetry uses transmitter settings for transmitter voltage min/max for battery bar gauge in screen title
* If you change a telemetry sensor's unit (for example m to ft), power cycle the transmitter to see changes
* If config option `Battery View` is set to `Total` but average cell voltage is displayed, send INAV CLI command: `set report_cell_voltage = OFF`
* When GPS accuracy (HDOP) is displayed as a decimal, the range is 0.8 - 5.3 and it's rounded to the nearest 0.5 HDOP.  This is due to HDOP being sent as a single integer from 0 to 9, not as the actual HDOP decimal value  (not applicable to Crossfire)

## Reporting Issues on Github

Submit issues and PRs in English only. Issues / PRs in other languages may be closed without further investigation.

Please include:

* The TX type (e.g. Radiomaster TX16S, Horus, Zorro etc.)
* The type and version of radio firmware (e.g. EdgeTX 2.8.0, OpenTX 2.3.15 etc).
* The flight controller and INAV version (e.g. MATEKF405, INAV 6.1.0)
* Details of Other active Lua widgets

Try running the script in the EdgeTX / OpenTX Companion. This will force debug mode and display additional information, in particular module line numbers. Please including this information in any Github issue.

Please also check that the problem can actually be reproduced in the firmware "Companion" application. If it cannot, it is probable that the maintainer cannot investigate the problem. You should consider raising a firmware issue if "Companion" and real hardware exhibit different behaviours.

For issues concerning discovery or display of sensor information, **please provide an EdgeTX / OpenTX telemetry log for TXs that provide such a facility**.
