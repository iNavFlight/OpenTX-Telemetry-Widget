# Developer Notes - EDGETX Compatibility

## Introduction

This guide describes now to modify the inav Lua Telemetry widget such that it works correctly in both EdgeTX and OpenTX.

EdgeTX is a touch-screen enabled fork of OpenTX. As part of the touch-screen enhancement, EdgeTX has expanded the way that some of the colour LCD APIs function. These changes are described in the [excellent EdgeTX API documenation](https://luadoc.edgetx.org/part_ii_-_opentx_lua_api_programming_guide/drawing-flags-and-colors).

## Summary of changes of the inav Lua widget

In order to keep the inav Lua widget compatible with both EdgeTX and OpenTX, the following are required for code that may run on colour screens.

* Do not modify the indexed colours as these are shared by the system theme and other widgets.
* Use the new `data.RBG()` function to convert RGB colour definitions to a Lua `COLOR`.
  - Do not call `lcd.RBG()` directly as it may return `nil` under some circumstances on OpenTX.
  - Do not use pre-computed integer values for colours; these will not work on EdgeTX.
* Do not set colours and display flags directly _on colour devices_. Use the new `data.set_flags()` function as this will work correctly on both EdgeTX and OpenTX. It will also work on older monochrome displays, but is unnecesasry in code that will not be executed on a colour device (e.g. `src/SCRIPTS/TELEMETRY/iNav/radar.lua`; note that `src/SCRIPTS/TELEMETRY/iNav/menu.lua` requires some care, it is runs on both colour and monochrome devices.

## Hints and tips

* The project should only contain a single instance of `CUSTOM_COLOR`; this is embedded in `src/SCRIPTS/TELEMETRY/iNav/func_h.lua` and is only used on OpenTX.
* The project uses its own colour map. It should not contain any other instances of `_COLOR` symbols.
* The user preference text colour is cached in `data.TextColor`, the user preference warning colour (which the widget modifies) is cached in `data.WarningColor`.

## Examples

```
local mycol = data.RGB(0, 121, 180)
local myflags = data.set_flags(MIDSIZE + RIGHT, mycol)
text(x, y, "A Message", myflags)
text(x1, y2, "More Text", myflags)
text(x2, y2, "Something else", data.set_flags(0, data.TextColor))
-- note we can't use myflags again (at least OpenTX) without resetting the value
line(x2, y2, x3, y3, SOLID, data.set_flags(0, LIGHTGREY))
```
