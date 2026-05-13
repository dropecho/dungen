# AGENTS.md — dropecho.dungen

Single source of truth for all AI agents working on this project.
See `.agents/` for deeper reference docs.

---

## Project Overview

**dropecho.dungen** (`haxelib: dropecho.dungen`, npm: `@dropecho/dungen`) is a cross-platform
procedural dungeon/map generation toolkit for games. It compiles to JS (ESM + CJS).

- **Version:** 1.5.0
- **License:** MIT
- **Targets:** JS (Node.js, browser via ESM/CJS)
- **Test runner:** `haxelib run dropecho.testing` (wraps utest + instrument)
- **Source root:** `src/`  · **Tests root:** `test/`

---

## Source Modules

| Module | Path | Description |
|---|---|---|
| `Map2d` | `src/dropecho/dungen/Map2d.hx` | Core 2D integer tile grid; extension methods via `@:using` |
| `Tile2d` | `src/dropecho/dungen/Tile2d.hx` | Simple `{x, y, val}` tile struct |
| `Pattern` | `src/dropecho/dungen/Pattern.hx` | Pattern matching helper for WFC/ConvChain |
| `bsp/BSPBuilder` | `src/dropecho/dungen/bsp/BSPBuilder.hx` | BSP tree splitter producing `BSPTree<BSPData>` |
| `bsp/BSPData` | `src/dropecho/dungen/bsp/BSPData.hx` | Typed `{x,y,width,height}` payload for BSP nodes |
| `generators/*` | `src/dropecho/dungen/generators/` | Standalone map generators (see `.agents/generators.md`) |
| `map_extensions/*` | `src/dropecho/dungen/map_extensions/` | Extension functions applied to `Map2d` via `@:using` |
| `regions/RegionMap` | `src/dropecho/dungen/regions/RegionMap.hx` | `Map2d` subclass with tagged regions + border graph |
| `regions/RegionManager` | `src/dropecho/dungen/regions/RegionManager.hx` | Static utilities: island removal, region tagging, expansion |
| `regions/extensions/RegionFill` | `src/dropecho/dungen/regions/extensions/RegionFill.hx` | Region fill extension for `Map2d` |
| `export/TiledExporter` | `src/dropecho/dungen/export/TiledExporter.hx` | Export map to Tiled JSON format |

See `.agents/generators.md` for generator details.
See `.agents/architecture.md` for design decisions and data flow.

---

## Directory Layout

```
src/dropecho/dungen/        # library source
  bsp/                      # BSP tree builder + data
  export/                   # map exporters (Tiled)
  generators/               # standalone map generation algorithms
  map_extensions/           # @:using extension functions for Map2d
  regions/                  # region detection, tagging, graph building
    extensions/             # @:using extension functions for region ops
test/                       # utest test suites (mirrors src structure)
  bsp/  export/  generators/  map/
    extensions/             # map extension tests
docs/                       # browser demo + API docs
dist/                       # compiled JS output (gitignored from build)
artifacts/                  # compiled test outputs (gitignored)
targets/                    # per-target HXML fragments
haxe_libraries/             # lix-managed dependency HXMLs
.agents/                    # extended AI agent documentation
```

---

## Build & Test

Prefer `npm` scripts over invoking Haxe tools directly — they handle flags and output paths consistently.

```bash
# Install deps
npm install          # also runs `lix download`

# Build (JS ESM + CJS)
npm run build

# Run tests (JS only)
npm test

# Build docs example
npm run build:docs
npm run build:bundle
```

Direct equivalents (only if npm scripts are unavailable):
- `haxe build.hxml` → `npm run build:haxe`
- `haxelib run dropecho.testing` → `npm test`

Tests compile to `artifacts/js_test.cjs` then run via Node.

See `.agents/testing.md` for patterns, coverage setup, and known gaps.

---

## Key Conventions

- `@:expose("dungen.ClassName")` on all public classes exported to JS
- `@:nativeGen` on classes that need native C# class hierarchy (currently only JS target active)
- Extension methods live in `map_extensions/` and attach to `Map2d` via `@:using` declarations in `Map2d.hx`
- Generators are all-static classes with a single `generate(opts)` entry point (except BSPBuilder which is instantiated)
- `dropecho.interop.Extender.defaults(base, opts)` used to merge optional config structs
- `seedyrng.Random` used for all RNG; seed is always a `String` field
- `@ignoreInstrument` annotation on debug/print methods to exclude from coverage

See `.agents/conventions.md` for full Haxe coding conventions.

---

## Dependencies

| Library | Purpose |
|---|---|
| `dropecho.ds` | `BSPTree`, `BSPNode`, `Graph`, `GraphNode`, `Set`, `Queue` |
| `dropecho.interop` | `AbstractMap`, `Extender.defaults` for config merging |
| `seedyrng` | Seeded RNG (`Random` class) |
| `dropecho.testing` | Test runner (wraps utest + instrument) |
| `utest` | Assertion library (`utest.Assert`, `utest.Test`) |
| `instrument` | Code coverage instrumentation |
| `hxnodejs` | Node.js target support |

---

## Testing Notes

- Test files live in `test/` mirroring `src/` structure; any `*Tests.hx` is auto-discovered
- Test classes extend `utest.Test`; methods must be prefixed `test_` to run
- Coverage instrumentation is enabled in `test.hxml` via `instrument.Instrumentation.coverage`
- Coverage output: `artifacts/lcov.info` (lcov reporter)
- Run with: `haxelib run dropecho.testing` or `npm test`

See `.agents/testing.md` for patterns and gaps.
