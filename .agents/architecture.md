# Architecture

## Core Class Hierarchy

```
Map2d                               # 2D integer tile grid
  └── RegionMap extends Map2d       # tagged regions + border graph

Tile2d                              # {x, y, val} struct — coordinate + tile value

BSPBuilder (instantiated)           # builds BSPTree<BSPData> via recursive splitting
  BSPData                           # {x, y, width, height} BSP node payload
  BSPTree<BSPData>                  # from dropecho.ds — directed graph of BSPNode
  BSPNode<BSPData>                  # from dropecho.ds — left/right/parent links

RegionMap
  regions: AbstractMap<Int, Region> # region id → Region (tiles array)
  borders: AbstractMap<Int, Region> # border id → Region (tiles array)
  graph: Graph<Region, Region>      # adjacency graph between regions
```

## Extension Method Pattern

`Map2d` has no methods for operations like flood fill, BFS, neighbors, etc. — these live
in separate files under `map_extensions/` and are injected via `@:using` in `Map2d.hx`.

```haxe
@:using(dropecho.dungen.map_extensions.FloodFill)
@:using(dropecho.dungen.map_extensions.BFS)
@:using(dropecho.dungen.map_extensions.Neighbors)
// ...
class Map2d { ... }
```

This means `map.floodFill(x, y, type)` compiles to `FloodFill.floodFill(map, x, y, type)`.
Extension functions take `map:Map2d` as their first argument.

## Generator Pattern

All generators are static utility classes with a single `generate(opts)` entry point:

```
generators/
  CAGenerator       — cellular automata (multi-step smoothing)
  CellularGenerator — simple cellular automata
  FloorPlanGenerator — room layout from floor plan
  MazeGenerator     — maze generation
  MixedGenerator    — combines multiple generator outputs
  RandomGenerator   — random tile fill (used as CA seed)
  RoomGenerator     — places rooms into a BSPTree<BSPData>
  TunnelerGenerator — random-walk tunnel carver
  VillageGenerator  — village-style open map
  WalkGenerator     — random walk fill
  WFC               — Wave Function Collapse
  ConvChain         — convolution chain pattern matching
```

`BSPBuilder` is the exception — it is instantiated with config and has a `generate()` method.

## Region System

`RegionMap` construction pipeline:
1. Clone input `Map2d`
2. `distanceFill(0)` — flood-fill distance from walls
3. `findAndTagRegions(depth)` — label each connected floor region with a unique int tag
4. `expandRegionsByOne(depth)` × N — grow regions outward
5. `buildRegions()` — collect tile arrays per region
6. `findAndTagBorders()` + `buildBorders()` — identify border tiles between regions
7. `buildGraph()` — create `Graph<Region,Region>` edges where regions share a border

## Map2d Data Model

- `_mapData: Array<Int>` — flat row-major tile array
- Index formula: `(_width * y) + x`
- Tile values are plain integers; convention: `0` = wall, `1` = floor, higher = corridor/region tags
- `TileIterator` enables `for (tile in map)` iteration over `Tile2d` structs

## Key Design Decisions

### Extensions over methods
Keeping operations in separate `@:using` files avoids a monolithic `Map2d` class and lets
features be tree-shaken by the Haxe compiler (DCE).

### BSPBuilder produces a tree, not a map
`BSPBuilder.generate()` returns a `BSPTree<BSPData>` — callers then pass it to `RoomGenerator`
or other visitors to produce a `Map2d`. This separates space-partitioning from tile painting.

### RegionMap builds a graph
`RegionMap.graph` is a `Graph<Region,Region>` where edge data is the border `Region`.
This enables pathfinding and connectivity queries between rooms/areas.

### Flat Array storage
`_mapData` is a flat `Array<Int>` for cache locality and simple serialization. All
coordinate math goes through `XYtoIndex` / `indexToXY`.
