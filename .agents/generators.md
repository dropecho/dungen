# Generators Reference

All generators produce a `Map2d` (or `BSPTree<BSPData>` for `BSPBuilder`).
Tile convention: `0` = wall, `1` = floor, `2+` = corridor / other types.

---

## BSPBuilder

**File:** `src/dropecho/dungen/bsp/BSPBuilder.hx`
**Output:** `BSPTree<BSPData>`
**Pattern:** Instantiated class

Recursively splits a rectangular space into a BSP tree. Does not paint tiles — pass the
result to `RoomGenerator.buildRooms()` to get a `Map2d`.

```haxe
var bsp = new BSPBuilder({ width: 80, height: 40, depth: 6, seed: "abc" });
var tree = bsp.generate();
var map = RoomGenerator.buildRooms(tree, { padding: 1 });
```

Config fields (all optional): `width`, `height`, `minHeight`, `minWidth`, `depth`, `ratio`, `x`, `y`, `seed`.

---

## RoomGenerator

**File:** `src/dropecho/dungen/generators/RoomGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `buildRooms(tree, opts)`

Takes a `BSPTree<BSPData>` from `BSPBuilder` and paints rooms at BSP leaves plus
L-shaped corridors connecting sibling pairs.

Config: `tileCorridor`, `tileFloor`, `tileWall`, `padding`, `minWidth`, `minHeight`.

---

## CAGenerator (Cellular Automata)

**File:** `src/dropecho/dungen/generators/CAGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Seeds a random map then applies multiple CA smoothing steps. Steps control neighbor
cutoffs and inversion. Good for cave-like maps.

Config (`CA_PARAMS`): `width`, `height`, `start_fill_percent`, `seed`, `tile_floor`, `tile_wall`,
`useOtherType`, `steps: Array<{reps, r1_cutoff, r2_cutoff, invert}>`.

---

## RandomGenerator

**File:** `src/dropecho/dungen/generators/RandomGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Fills a map with random 0/1 based on `start_fill_percent`. Used internally by `CAGenerator`.

---

## TunnelerGenerator

**File:** `src/dropecho/dungen/generators/TunnelerGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Random-walk tunnel carver. Agents walk around and carve floor tiles. Good for winding
corridor maps.

---

## WalkGenerator

**File:** `src/dropecho/dungen/generators/WalkGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Simple random walk that paints floor tiles. Simpler/faster than TunnelerGenerator.

---

## MazeGenerator

**File:** `src/dropecho/dungen/generators/MazeGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Generates a perfect maze (no loops). Uses recursive backtracking or similar algorithm.

---

## CellularGenerator

**File:** `src/dropecho/dungen/generators/CellularGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Simpler single-pass cellular automata variant.

---

## MixedGenerator

**File:** `src/dropecho/dungen/generators/MixedGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Combines outputs from multiple generators by compositing/blending tile values.

---

## FloorPlanGenerator

**File:** `src/dropecho/dungen/generators/FloorPlanGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Generates a map from a floor plan layout, placing discrete rooms.

---

## VillageGenerator

**File:** `src/dropecho/dungen/generators/VillageGenerator.hx`
**Output:** `Map2d`
**Pattern:** Static `generate(opts)`

Generates an open village-style map with building footprints and paths.

---

## WFC (Wave Function Collapse)

**File:** `src/dropecho/dungen/generators/WFC.hx`
**Output:** `Map2d`
**Pattern:** Instantiated or static

Implements the Wave Function Collapse algorithm using a `Pattern` source.
Samples from an input pattern and collapses the output grid to a consistent result.

---

## ConvChain

**File:** `src/dropecho/dungen/generators/ConvChain.hx`
**Output:** `Map2d`
**Pattern:** Static

Markov-chain based pattern synthesis. Uses a sample input pattern to generate
statistically similar output maps.
