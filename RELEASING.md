# How to Release Lua Telemetry

This documents the release process for maintainers. It reflects what actually
builds and ships today (`Makefile` + `.github/workflows/`), not the legacy
`release` shell script at the repo root, which predates the current
`WIDGETS/`-based layout and is no longer used by CI or by the release
workflow.

## Versioning

There is a single source of truth for the version number: the `VERSION`
string in `src/SCRIPTS/TELEMETRY/iNav.lua`:

```lua
local VERSION = "2.4"
```

This is what the widget displays on the transmitter, and it's also what the
`Makefile` reads to name build output (`make print-version`, or
`grep VERSION src/SCRIPTS/TELEMETRY/iNav.lua`). There is no separate
version file — bumping this string *is* bumping the version.

**Bump this before tagging, not after.** If you tag first and bump later,
the tagged commit's source disagrees with what ships in the zip asset built
from a later commit (this happened with the 2.4 release — see "Lessons from
the 2.4 release" below).

### Tag naming

Use `vX.Y.Z` (three-part semver, `v` prefix) — e.g. `v2.4.0`. Past tags have
been inconsistent (`v2.2.0`, `v.2.3.0` with a stray dot, and `2.4` with no
prefix at all), which is exactly why `release.yml`'s tag trigger currently
has to match more than one pattern (see below). Stick to `vX.Y.Z` going
forward so the trigger doesn't need further patching.

## What gets built

`make dist` and `make dist-lua` are two independent targets — `dist` does
not depend on `dist-lua`, so building one does not build the other:

- **`make dist`** — compiles every `.lua` file under `src/SCRIPTS/` and
  `src/WIDGETS/` to stripped bytecode (`luac -s`) and zips it as
  `dist/LuaTelemetry_v<VERSION>.zip`. This is what most users install.
- **`make dist-lua`** — zips the raw, uncompiled `src/` tree as-is, no
  compilation, as `dist/LuaTelemetry_v<VERSION>_lua.zip`. Needed for
  EdgeTX 2.11rc1+ (which broke loading precompiled Lua) and for the
  simulator.

Both files are added to `src/SCRIPTS/TELEMETRY/iNav/*.lua` etc. via
wildcard, so **new view files (e.g. `tx15.lua`, `tx16s.lua`) are picked up
automatically** — no Makefile changes needed when adding a new screen
layout.

To build both locally:

```bash
make dist dist-lua
```

Both zips land in `dist/`.

## Automated builds

- **`.github/workflows/ci.yml`** — runs on every PR and push, builds both
  zip variants (`make dist dist-lua`) as a CI artifact. Doesn't touch
  releases.
- **`.github/workflows/release.yml`** — runs on a tag push matching `v*` or
  a bare `X.Y*` numeric tag (`[0-9]+.[0-9]+*`), builds both zips, and
  uploads them to the GitHub release matching that tag name via
  `svenstaro/upload-release-action`.

**A release only gets assets automatically if the tag matches one of those
two patterns.** If you tag something that doesn't match (e.g. a typo, or
some future new format), the workflow silently never fires — GitHub won't
warn you, the release will just have zero assets. Always check
`gh release view <tag> --repo iNavFlight/OpenTX-Telemetry-Widget` after
tagging to confirm assets showed up (see checklist below).

## Release procedure

1. **Bump `VERSION`** in `src/SCRIPTS/TELEMETRY/iNav.lua` and merge that to
   `master` (PR, same as any other change).
2. **Tag the merged commit** with `vX.Y.Z`:
   ```bash
   git tag vX.Y.Z <merged-commit-sha>
   git push origin vX.Y.Z
   ```
   Or via `gh` without a local checkout:
   ```bash
   gh release create vX.Y.Z --repo iNavFlight/OpenTX-Telemetry-Widget \
     --target <merged-commit-sha> --title "vX.Y.Z <short description>" \
     --generate-notes
   ```
3. **Wait ~30s, then verify the workflow ran and assets attached:**
   ```bash
   gh run list --repo iNavFlight/OpenTX-Telemetry-Widget --workflow=release.yml --limit 1
   gh release view vX.Y.Z --repo iNavFlight/OpenTX-Telemetry-Widget
   ```
   Confirm both `LuaTelemetry_v<version>.zip` and
   `LuaTelemetry_v<version>_lua.zip` are listed as assets.
4. If assets are missing, the tag likely didn't match the trigger patterns,
   or the workflow failed. Check `gh run list` for a failed/missing run,
   fix (see Troubleshooting), and re-push the tag or manually build+upload:
   ```bash
   make clean-obj clean-zip
   make dist dist-lua
   gh release upload vX.Y.Z dist/*.zip --repo iNavFlight/OpenTX-Telemetry-Widget
   ```

## Release Notes

Release notes should describe what has changed, from the point of view of what users will want to know. They should describe how a new feature can be used or how a change affects users, as opposed to the details of how it is implemented.

Be sure to point out changes which have backwards compatibility changes or would surprise experienced users.

The release notes should also describe the two zip files provided, using text such as the following:
```
Two Zip files are provided:

LuaTelemetry v2.3.0_lua.zip : Source LUA, compiles on the device, may be required in the simulator. Also for EdgeTX 2.11rc1 and later.

LuaTelemetry_v2.3.0.zip : Compiled LUA, should work on all radios (prior to EdgeTX 2.11rc1, which unfortunately breaks pre-compiled Lua).
```

## Troubleshooting

**Tag was pushed pointing at the wrong commit (e.g. before a needed
version-bump or fix commit landed).** You can move a tag after the fact by
updating the underlying ref, as long as the release has no assets yet that
depend on the old target:
```bash
gh api -X PATCH repos/iNavFlight/OpenTX-Telemetry-Widget/git/refs/tags/vX.Y.Z \
  -f sha="<correct-full-40-char-sha>" -F force=true
```
Moving the ref this way re-fires the tag-push event, so `release.yml` will
run again against the new commit automatically.

**`git push` denied with 403 even though `gh api .../permissions` shows full
push access.** A restricted `GITHUB_TOKEN` env var can pin `git`/`gh` to a
fine-grained PAT that blocks raw git push while still reporting full
permissions via the API. This is intentional (limits unattended agent
actions) — don't work around it without asking whoever is driving the
release first, every time, even if they approved it earlier in the same
session.

## Lessons from the 2.4 release

The `2.4` release was originally tagged and published with **zero assets**,
and the reasons compound into the process above:

- The tag `2.4` didn't match the old `release.yml` trigger (`v*` only), so
  the workflow never ran.
- Even if it had matched, the workflow only ran `make dist` — the
  `_lua.zip` asset (present on prior releases) had never been automated;
  someone had to build and upload it by hand every time.
- The `VERSION` string was never bumped before tagging, so the source at
  the tagged commit still said `2.3.0`.
- The tag was created before the version-bump/workflow-fix PR was merged,
  so it had to be moved to the correct commit afterward (see
  Troubleshooting above).

All four are now fixed: `release.yml` matches both tag conventions, builds
both zips, and this document exists so version-bump-before-tag isn't
rediscovered the hard way again.
