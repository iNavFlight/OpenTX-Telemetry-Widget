## INAV Lua Telemetry Flight Status for EdgeTX and OpenTX

### Smartport and Crossfile radios by various manufacturers.

- **New documentation:** https://luatelemetry.readthedocs.io/en/latest/

## Interface

#### [Video of Lua Telemetry running on X9D+](https://youtu.be/YaUgywuT1YM)

#### Colour LCD "big screen" view

![sample](assets/iNavHorus.png "View on Horus transmitters")&nbsp;&nbsp;
![sample](assets/iNavNirvana.jpg "View on Nirvana NV14 transmitter")

#### Pilot (glass cockpit) view for fixed wing pilots (Monochrome / small LCD radios)

![sample](assets/iNavQX7pilot.png "Pilot view on Q X7, X-Lite & Jumper T12")&nbsp;&nbsp;
![sample](assets/iNavX9Dpilot.png "Pilot view on Taranis X9D, X9D+ and X9E")

#### Radar (map) view (Monochrome / small LCD radios)

![sample](assets/iNavQX7radar.png "Radar view on Q X7, X-Lite & Jumper T12")&nbsp;&nbsp;
![sample](assets/iNavX9Dradar.png "Radar view on Taranis X9D, X9D+ and X9E")

#### Altitude graph view (Monochrome / small LCD radios)

![sample](assets/iNavQX7alt.png "Altitude graph view on Q X7, X-Lite & Jumper T12")&nbsp;&nbsp;
![sample](assets/iNavX9Dalt.png "Altitude graph view on Taranis X9D, X9D+ and X9E")

#### Classic view (Monochrome / small LCD radios)

![sample](assets/iNavQX7.png "Classic view on Q X7, X-Lite & Jumper T12")&nbsp;&nbsp;
![sample](assets/iNavX9D.png "Classic view on Taranis X9D, X9D+ and X9E")

## Features

* Supported receivers: FrSky (compatible) telemetry receivers (X, R9 and D series) and Crossfire receivers.
* Supported transmitters: FrSky Taranis and Horus transmitters, Jumper T12, T16, FLYSKY Nirvana NV14, Radiomaster TX16S, TX12, Zorro, Boxer (at least).
* Note other transmitters may work, but are not considered "supported".
* Compatible with Betaflight using FrSky X or R9 series receivers (with reduced functionality) and TBS Crossfire support with Betaflight v4.0.0+
* Launch/pilot-based model orientation and location indicators (great for lost orientation/losing sight of your model)
* Compass-based direction indicator (with magnetometer sensor on multirotor or fixed-wing with GPS)
* Pilot (glass cockpit) view which includes attitude indicator as well as pilot-familiar layout of additional data
* Radar (map) view shows model in relationship to home position, can be displayed either as launch/pilot-based or compass-based orientation
* Altitude graph view shows altitude for the last 1-6 minutes
* Colour LCD transmitters show all views at the same time, and include additional features like roll scale
* Bar gauges for Fuel (% battery mAh capacity remaining), Battery voltage, RSSI strength, Transmitter battery, GPS accuracy (HDOP), Variometer (and Altitude for X9D, X9D+ and X9E transmitters)
* Display and voice alerts for flight modes and flight mode modifiers (altitude hold, heading hold, home reset, etc.)
* Voice notifications for % battery remaining (based on current), voltage low/critical, high altitude, lost GPS, ready to arm, armed, disarmed, etc.
* GPS info: Satellites locked, GPS accuracy (HDOP), GPS altitude, GPS coordinates. Also logs the last GPS location (reviewed from the config menu)
* Playback previous flights via telemetry log files, including fast forward, rewind, and pause features
* Display of current/maximum: Altitude, Distance, Speed and Current
* Display of current/minimum: Battery voltage, RSSI strength
* Title display of model name, flight timer, transmitter voltage and receiver voltage
* Menu configuration options can be changed from inside the script and can be unique to each model
* Speed and distance values are displayed in metric or imperial based on transmitter's telemetry settings
* Voice files, modes and config menu in English, German, French or Spanish (more languages to follow)

## Requirements

Supported environments are given below, older versions may also work but are unsupported.

* [INAV v6.0+](https://github.com/iNavFlight/inav/releases) running on your flight controller.Also compatible with Betaflight v4.0.0+ (with reduced functionality)
* [OpenTX v2.3.14+](http://www.open-tx.org/) running on Taranis Q X7/Q X7S, X9D/X9D+, X9E, X9 Lite, X-Lite/X-Lite Pro, Horus X10/X10S or X12S
* [EdgeTX v2.8.0+](https://edgetx.org/) running on a [supported radio](https://github.com/EdgeTX/edgetx.github.io/wiki/Frequently-Asked-Questions).
* FrSky X, R9 or D series telemetry receiver: X4RSB, X8R, XSR, R-XSR, XSR-M, XSR-E, RX4R, RX6R, R9, R9 Slim, R9 Slim+, R9 Mini, R9 MM, D8R-II plus, D8R-XP, D4R-II, etc. or any Crossfire receiver: Micro, Nano, Diversity, ELRS etc.
* GPS - On the aircraft.

## Suggested Sensors

* Altimeter/barometer (GPS altitude used if barometer not present)
* Magnetometer/compass for multi-rotor (fixed-wing craft use GPS for directional info)
* Current/amperage (for fuel gauge)

## Notes

* Crossfire is not fully supported with OpenTX, due to a long-standing OpenTX issue; EdgeTX is recommended for use with Crossfire (and generally).
* Some telemetry is missing from Crossfire: HDOP, GPS altitude and some secondary flight mode notifications like heading hold
* Betaflight v4.0.0+ mostly works, except for some GPS and flight mode information which is missing from Betaflight
* Use the OSD to control VTx band, frequency and power (except for on 2019 series Taranis transmitters, Betaflight's lua script can't run at the same time as INAV Lua Telemetry due to limited transmitter memory)

## Special Thanks

* [RadioMaster](https://www.radiomasterrc.com/) - Sponsoring [RadioMaster Boxer](https://www.radiomasterrc.com/collections/boxer-1) support as well as general small screen radio and ELRS maintenance.
* [Team Black Sheep](https://www.team-blacksheep.com/) - Sponsoring TBS Crossfire telemetry support
* [FrSky](https://www.frsky-rc.com/) - Sponsoring [FrSky Horus](https://us.banggood.com/custlink/vG3D6Kiprr) transmitter support
* [Jumper](https://www.jumper.xyz/) - Sponsoring Jumper T16 transmitter support
* [FLYSKY](https://www.flysky-cn.com/) - Sponsoring [FLYSKY Nirvana NV14](https://us.banggood.com/custlink/GmGm0GZcpt) transmitter support

## Setup

* [Lua Telemetry Docs](https://luatelemetry.readthedocs.io/en/latest/)
* [Download latest release](https://github.com/iNavFlight/OpenTX-Telemetry-Widget/releases/latest)
* [Installation Instructions](https://luatelemetry.readthedocs.io/en/latest/Getting-Started/)
* [Upgrade Instructions](https://luatelemetry.readthedocs.io/en/latest/Upgrade/)
* [Download Options](https://luatelemetry.readthedocs.io/en/latest/Getting-Started/#download-options)

## Information & Settings

* [Configuration Settings and more](https://luatelemetry.readthedocs.io/en/latest/Configuration-Settings/) (!)
* [Playback Telemetry Logs](https://luatelemetry.readthedocs.io/en/latest/Configuration-Settings/#playback-telemetry-log-files)

## Support

* [Tips & Common Problems](https://luatelemetry.readthedocs.io/en/latest/Tips-%26-Common-Problems/)
* [Support Issues](https://github.com/iNavFlight/OpenTX-Telemetry-Widget/issues?q=is%3Aissue)
* ~~Support Chat (Telegram)~~: Contact current maintainer @nvrm17 on telegram for any questions

## Other

* [Upgrade to Development Build](https://luatelemetry.readthedocs.io/en/latest/Upgrade/#upgrade-to-development-build)
* [Release History](https://luatelemetry.readthedocs.io/en/latest/Change-Log)
* [Multilingual Support](https://luatelemetry.readthedocs.io/en/latest/Multilingual-Support/)
* [License](https://github.com/iNavFlight/OpenTX-Telemetry-Widget/blob/master/LICENSE)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.baconorbeer.com/"><img src="https://avatars.githubusercontent.com/u/2592128?v=4?s=64" width="64px;" alt="Tim Eckel"/><br /><sub><b>Tim Eckel</b></sub></a><br /><a href="#question-teckel12" title="Answering Questions">💬</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=teckel12" title="Code">💻</a> <a href="#data-teckel12" title="Data">🔣</a> <a href="#design-teckel12" title="Design">🎨</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=teckel12" title="Documentation">📖</a> <a href="#ideas-teckel12" title="Ideas, Planning, & Feedback">🤔</a> <a href="#maintenance-teckel12" title="Maintenance">🚧</a> <a href="#research-teckel12" title="Research">🔬</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.daria.co.uk/"><img src="https://avatars.githubusercontent.com/u/158229?v=4?s=64" width="64px;" alt="Jonathan Hudson"/><br /><sub><b>Jonathan Hudson</b></sub></a><br /><a href="#question-stronnag" title="Answering Questions">💬</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=stronnag" title="Code">💻</a> <a href="#ideas-stronnag" title="Ideas, Planning, & Feedback">🤔</a> <a href="#maintenance-stronnag" title="Maintenance">🚧</a> <a href="#research-stronnag" title="Research">🔬</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/pulls?q=is%3Apr+reviewed-by%3Astronnag" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/nm17"><img src="https://avatars.githubusercontent.com/u/23419131?v=4?s=64" width="64px;" alt="Даниил Николаев (NeverMine)"/><br /><sub><b>Даниил Николаев (NeverMine)</b></sub></a><br /><a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/issues?q=author%3Anm17" title="Bug reports">🐛</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=nm17" title="Code">💻</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=nm17" title="Documentation">📖</a> <a href="#ideas-nm17" title="Ideas, Planning, & Feedback">🤔</a> <a href="#infra-nm17" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-nm17" title="Maintenance">🚧</a> <a href="#tool-nm17" title="Tools">🔧</a> <a href="#translation-nm17" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fiam"><img src="https://avatars.githubusercontent.com/u/41529?v=4?s=64" width="64px;" alt="Alberto García Hierro"/><br /><sub><b>Alberto García Hierro</b></sub></a><br /><a href="#audio-fiam" title="Audio">🔊</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/issues?q=author%3Afiam" title="Bug reports">🐛</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=fiam" title="Code">💻</a> <a href="#design-fiam" title="Design">🎨</a> <a href="#ideas-fiam" title="Ideas, Planning, & Feedback">🤔</a> <a href="#platform-fiam" title="Packaging/porting to new platform">📦</a> <a href="#translation-fiam" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.mrd-rc.com/"><img src="https://avatars.githubusercontent.com/u/17590174?v=4?s=64" width="64px;" alt="Darren Lines"/><br /><sub><b>Darren Lines</b></sub></a><br /><a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=MrD-RC" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/t413"><img src="https://avatars.githubusercontent.com/u/326829?v=4?s=64" width="64px;" alt="Tim O'Brien"/><br /><sub><b>Tim O'Brien</b></sub></a><br /><a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=t413" title="Code">💻</a> <a href="#ideas-t413" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Peschi90"><img src="https://avatars.githubusercontent.com/u/42059226?v=4?s=64" width="64px;" alt="Peschi90"/><br /><sub><b>Peschi90</b></sub></a><br /><a href="#translation-Peschi90" title="Translation">🌍</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Louis-Land"><img src="https://avatars.githubusercontent.com/u/42384091?v=4?s=64" width="64px;" alt="Louis-Land"/><br /><sub><b>Louis-Land</b></sub></a><br /><a href="#ideas-Louis-Land" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://quadmeup.com/"><img src="https://avatars.githubusercontent.com/u/966811?v=4?s=64" width="64px;" alt="Paweł Spychalski"/><br /><sub><b>Paweł Spychalski</b></sub></a><br /><a href="#question-DzikuVx" title="Answering Questions">💬</a> <a href="#ideas-DzikuVx" title="Ideas, Planning, & Feedback">🤔</a> <a href="#infra-DzikuVx" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-DzikuVx" title="Maintenance">🚧</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://frank.petril.li/"><img src="https://avatars.githubusercontent.com/u/8746034?v=4?s=64" width="64px;" alt="Frank Petrilli"/><br /><sub><b>Frank Petrilli</b></sub></a><br /><a href="#question-FrankPetrilli" title="Answering Questions">💬</a> <a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=FrankPetrilli" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://bandism.net/"><img src="https://avatars.githubusercontent.com/u/22633385?v=4?s=64" width="64px;" alt="Ikko Eltociear Ashimine"/><br /><sub><b>Ikko Eltociear Ashimine</b></sub></a><br /><a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=eltociear" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/MRC3742"><img src="https://avatars.githubusercontent.com/u/26642502?v=4?s=64" width="64px;" alt="MRC3742"/><br /><sub><b>MRC3742</b></sub></a><br /><a href="https://github.com/iNavFlight/OpenTX-Telemetry-Widget/commits?author=MRC3742" title="Code">💻</a> <a href="#research-MRC3742" title="Research">🔬</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
