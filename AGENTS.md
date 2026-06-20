# AGENTS.md — dropecho.dungen

Single source of truth for all AI agents working on this project.

## Agent Instructions

- **Always use the `haxe` skill** when reading or writing any `.hx` or `.hxml` file.
- **Always use the Haxe LSP** (`LSP` tool) for navigating code — go-to-definition, find
  references, hover types — before grepping or reading files manually.
- **Never co-author or co-sign commits.** Do not add `Co-Authored-By` trailers,
  `Signed-off-by` lines, or any other attribution/sign-off trailers to commit messages.
- **Never add section/region divider comments** (e.g. `// ── Foo ──`, `// --- Foo ---`,
  `#region`). Organize code with ordering and doc comments instead.

---

## Project Overview

**dropecho.dungen** (`haxelib: dropecho.dungen`, npm: `@dropecho/dungen`) is a **procedural
generation toolkit for games** — map generators (cellular, WFC, BSP, tunneler, rooms, village,
walk, …), a `Map2d` grid with a rich set of map extensions, and exporters (e.g. Tiled).
It compiles to multiple targets and is published to both haxelib and npm.

- **Targets:** JS CommonJS, JS ES module (+ `.d.ts` via genes). C#, Python, and docs targets
  ship commented-out in `build.hxml`.
- **Test runner:** `dropecho.testing` (auto-discovery) over `utest`; `instrument` for coverage.
- **Dependencies:** `seedyrng`, `dropecho.ds`, `dropecho.interop` (managed via **lix**).
- **Source root:** `src/` · **Tests root:** `test/`
- **Releases:** automated via `semantic-release` (+ `semantic-release-haxelib`).

---

## Directory Layout

```
src/dropecho/dungen/         # library source
  Map2d.hx                   # core 2D grid + Tile2d, @:expose("dungen.Map2d")
  RegionMap.hx
  generators/                # map generators (CA, WFC, BSP-driven, rooms, village, …)
  map/                       # Pattern, Map2dExtensions, and map/extensions/* (FloodFill, BFS, …)
  bsp/                       # BSP builder + data
  export/                    # exporters (TiledExporter)
test/                        # utest cases, auto-discovered by filename (*Tests.hx)
build.hxml                   # multi-target build (shared opts + --each/--next)
targets/                     # one hxml per target (js, js-esm, cs, docs)
test.hxml                    # test build (libs/targets only — no -main)
.dropecho.testing.json       # test-runner config (coverage, root_package, hxml)
haxe_libraries/              # lix-pinned dependency hxml files
dist/                        # compiled output
artifacts/                   # compiled test output + coverage reports
```

There is no hand-written test main/suite: `dropecho.testing` generates the entry point and
registers every `*Tests.hx` class on the classpath (note the plural — `Test.hx` files are
**not** discovered).

---

## Build & Test

Prefer `npm` scripts over invoking Haxe tools directly. Dependencies resolve through **lix**
(`.haxerc` + `haxe_libraries/`); `npm install` runs `lix download` to fetch them.

```bash
npm run build    # → haxe build.hxml   (JS cjs + JS esm)
npm test         # → lix dropecho.testing
npm run clean    # remove dist/ and artifacts/
npm run build:docs  # generate dox API docs into docs/
```

- `build.hxml` puts shared options (libs, class path, `--macro include`, `-D analyzer-optimize`,
  `-D dce=no`) before `--each`, then builds each `targets/*.hxml` separated by `--next`.
- `test.hxml` lists libs/targets only — **no `-main`**. The `dropecho.testing` runner injects
  its `AutoTest` entry point, then builds and runs the suite on every target in the hxml
  (JS / Node by default).
- **Coverage** is wired directly in `test.hxml` via the `instrument` library
  (`--macro instrument.Instrumentation.coverage(...)` + `-D coverage-lcov-reporter`). `npm test`
  writes an lcov report to `artifacts/lcov.info` with `SF` paths relative to the project root.
  (The `instrument` block in `.dropecho.testing.json` records the same intent, but the installed
  `dropecho.testing` runner has its coverage wiring commented out, so the hxml drives it.)

To type-check quickly without generating output: `haxe build.hxml --no-output`.

---

## Key Conventions

- `@:expose("Name")` on each public class sets its JavaScript export name (independent of the
  Haxe package). Use it on the classes you want in the JS bundle.
- Give every public function a full doc comment with `@param`/`@return`.
- Tests are `utest` cases: each class is named `*Tests.hx`, `extends utest.Test`, with
  `test_`-prefixed methods using `utest.Assert` (use `Assert.floatEquals` for floats).
