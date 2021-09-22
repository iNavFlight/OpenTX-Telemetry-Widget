## INAV Lua Telemetry Flight Status fork for EdgeTX / Horus, TX16S etc.

This fork works for EdgeTX (2.5 dev of 2021-09-20 and later) and TX16S (Horus). It may not work elsewhere. Nivana has also been updated, but is untested.

* Colours are somewhat correct
* The main screen is not corrupted
* Prefers compilation on the TX, avoiding incompatible Lua binary formats

There are two branches:

* master : EdgeTX only. The most stable.
* edgeTX_and_openTX_compat : In theory, works on both EdgeTX and OpenTX. Less well tested.

Tested Platforms

* TX16S, EdgeTX (both zip files)
* Simulator. Both zip files tested on EdgeTX and OpenTX against TX16S.


#### Installation

* Unzip the relevant release Zip file into the root of the SDcard (real or simulator image).

#### In use

Some bench test images:

![EdgeTX](assets/edgetx/screen-2021-09-21-204511.png)

![HDOP warning](assets/edgetx/screen-2021-09-21-210839.png)

![HDOP OK](assets/edgetx/screen-2021-09-21-211319.png)

![No Telemetry](assets/edgetx/screen-2021-09-21-211359.png)

#### Future

At some stage, this will be made to work on both EdgeTX and OpenTX; then it can go back upstream.

#### Official Documentation

Please refer to the [OpenTX INAV telemetry widget page](https://github.com/iNavFlight/OpenTX-Telemetry-Widget).
