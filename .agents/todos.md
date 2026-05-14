# Todos

Each item is self-contained and safe to work on in a separate worktree.

---

## Bugs

### 1. RegionManager.expandRegions() returns wrong map
`src/dropecho/dungen/regions/RegionManager.hx`

The last line returns `map` (the unmodified input) instead of `expandedMap`.
All work is done on `expandedMap` and silently discarded.
Fix: change the final `return map;` to `return expandedMap;`.

### 2. WalkGenerator sets initial tile to wall
`src/dropecho/dungen/generators/WalkGenerator.hx`

Line `map.set(walkerPos.x, walkerPos.y, 0);` hardcodes `0` (wall) instead of
`params.tile_floor`. The walker's starting tile is never carved, which is
inconsistent with the rest of the walk.
Fix: replace `0` with `params.tile_floor`.

### 3. RegionManager.findAndTagBorders() iterates wrong map
`src/dropecho/dungen/regions/RegionManager.hx`

`borderMap` is initialized to all zeros, then immediately iterated to seed it —
but the loop iterates `borderMap` itself instead of the input `map`. So `borderType`
tiles are never found and the border map is always empty.
Fix: change `for (tile in borderMap)` to `for (tile in map)` in the seeding loop.

### 4. WFC.getPossibilities() ignores this.n
`src/dropecho/dungen/generators/WFC.hx`

`getRect` is called with hardcoded `width: 2, height: 2` instead of `this.n`.
Changing `n` at construction time has no effect on the extracted pattern size.
Fix: replace the literal `2` values with `this.n`.

### 5. ConvChain.processWeights() swaps x and y
`src/dropecho/dungen/generators/ConvChain.hx`

The outer loop iterates over `height` and assigns it to `x`; the inner loop iterates
over `width` and assigns it to `y`. For non-square samples this extracts wrong rects.
Fix: swap so the outer loop uses `sample._width` for `x` and the inner uses
`sample._height` for `y`.

---

## Convention Fixes

### 6. Type RoomGenerator Dynamic params
`src/dropecho/dungen/generators/RoomGenerator.hx`

`buildRooms(tree, ?opts:Dynamic = null)` still uses Dynamic.
`RoomParams` class already exists with all fields. Add a `RoomConfigProps` typedef
(all fields optional) matching `RoomParams`, and change the signature to
`?opts:RoomConfigProps = null`. Use `Extender.defaults(new RoomParams(), opts)`.
See `BSPBuilder.hx` for the exact pattern.

### 7. Add missing @:expose on generator classes
Multiple files in `src/dropecho/dungen/generators/`

These classes are missing `@:expose("dungen.ClassName")`:
- `RandomGenerator` → `@:expose("dungen.RandomGenerator")`
- `WalkGenerator` → `@:expose("dungen.WalkGenerator")`
- `MazeGenerator` → `@:expose("dungen.MazeGenerator")`
- `TunnelerGenerator` → `@:expose("dungen.TunnelerGenerator")`
- `CAGenerator` → `@:expose("dungen.CAGenerator")`
- `CellularGenerator` → `@:expose("dungen.CellularGenerator")`
- `RoomGenerator` → `@:expose("dungen.RoomGenerator")`
- `VillageGenerator` → `@:expose("dungen.VillageGenerator")`
- `MixedGenerator` → `@:expose("dungen.MixedGenerator")`

Also fix `BSPBuilder`'s existing annotation: `@:expose("dungen.BSPGenerator")` should
be `@:expose("dungen.BSPBuilder")` to match the actual class name.

### 8. Normalize PARAMS naming convention
`src/dropecho/dungen/generators/CAGenerator.hx`,
`src/dropecho/dungen/generators/CellularGenerator.hx`

`CA_PARAMS` and `CELLULAR_PARAMS` use ALL_CAPS (old style). Rename to `CAParams` and
`CellularParams`. Add matching typedefs `CAConfigProps` and `CellularConfigProps`
(all fields optional) so they can accept anonymous struct literals the same way
`MazeGenerator`, `TunnelerGenerator`, etc. do.
Update all call sites and test files after renaming.

### 9. Fix BSPBuilder @:expose name mismatch
`src/dropecho/dungen/bsp/BSPBuilder.hx`

`@:expose("dungen.BSPGenerator")` should be `@:expose("dungen.BSPBuilder")`.
The old name `BSPGenerator` is a leftover from a rename. Also update
`docs/index.js` which references `dungen.BSPBuilder` (it was already updated),
so verify no other references to the old name remain.
Note: this is a breaking change for any JS callers using `dungen.BSPGenerator` —
confirm it's intentional before merging.

---

## Missing Tests

### 10. Add tests for CellularGenerator
`test/generators/CellularGeneratorTests.hx` (new file)

`CellularGenerator` is distinct from `CAGenerator` (different algorithm, different
params: `bornCount`, `surviveCount`, `passes`). Cover:
- Generated map has correct dimensions
- Map contains both floor and wall tiles after processing
- `passes` param actually runs multiple iterations (compare passes=1 vs passes=3)
- Same seed produces identical output

### 11. Add tests for RoomGenerator
`test/generators/RoomGeneratorTests.hx` (new file)

Currently only smoke-tested in `Map2dTests`. Cover:
- Output map dimensions match BSP root dimensions
- Map contains floor tiles and wall tiles
- `padding` param reduces room size (compare padding=0 vs padding=4)
- `tileFloor` and `tileCorridor` params are respected in output tile values
- `seed` param produces deterministic output

### 12. Add tests for VillageGenerator
`test/generators/VillageGeneratorTests.hx` (new file)

Currently only smoke-tested. Cover:
- Output map dimensions match BSP root dimensions
- Map contains wall tiles (building outlines) and floor tiles (interiors)
- `seed` param produces deterministic output

### 13. Add tests for ConvChain
`test/generators/ConvChainTests.hx` (new file)

Read `src/dropecho/dungen/generators/ConvChain.hx` and
`src/dropecho/dungen/Pattern.hx` first.
Cover:
- `generate()` returns a map of the requested dimensions
- Output contains only tile values present in the sample
- Same seed produces identical output (set `gen.rng.setStringSeed` before generate)

---

## Dead Code Cleanup

### 14. Remove commented-out makeSplit in BSPBuilder
`src/dropecho/dungen/bsp/BSPBuilder.hx`

~70 lines of commented-out alternative `makeSplit()` implementation at the bottom of
the file (lines ~128–198). The active implementation above it is complete and tested.
Delete the commented block entirely.

### 15. Remove commented-out seep() in DistanceFill
`src/dropecho/dungen/map_extensions/DistanceFill.hx`

~24 lines of commented-out `seep()` function at the bottom of the file. It was never
completed and is not referenced anywhere. Delete it.

### 16. Fix or delete @Ignored tests in RegionManagerTests
`test/map/extensions/RegionManagerTests.hx`

Several test methods are marked `@Ignored`. Read each one: if the underlying
functionality is now working, remove `@Ignored` and add/fix assertions. If the test is
genuinely incomplete or tests unimplemented behavior, delete the method rather than
leaving it permanently ignored.
