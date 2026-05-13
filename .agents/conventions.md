# Haxe Coding Conventions

## Metadata

- `@:expose("dungen.ClassName")` — export to JS global scope; all public classes use this
- `@:nativeGen` — generate native class hierarchy (used on `Map2d`, `RegionMap`, etc.)
- `@:struct` — value-type hint (used on `Region`, `Tile2d`)
- `@:using(...)` — attach extension methods to a class
- `@ignoreInstrument` — exclude method from coverage instrumentation (use on debug/print methods)

## Naming

- Classes: `PascalCase`
- Methods/fields: `camelCase`
- Private fields: `_camelCase` (underscore prefix, e.g. `_width`, `_mapData`)
- Type parameters: single uppercase letter (`T`)
- Test methods: `test_snake_case_description` (required prefix for utest discovery)
- Generator config typedefs use suffix `Props` (e.g. `BSPBuilderConfigProps`)

## Config / Options Pattern

Generators use a two-class pattern for config:

```haxe
typedef FooConfigProps = { ?width:Int, ?height:Int }  // all-optional anonymous struct

class FooConfig {           // concrete class with defaults
  public var width:Int = 120;
  public var height:Int = 60;
}

class FooBuilder extends FooConfig {
  public function new(?ops:FooConfigProps = null) {
    Extender.extendThis(this, ops);  // merge opts onto this
  }
}
```

Static generators use `Extender.defaults(new Params(), opts)` to merge an anonymous struct
into the default params object.

## Extension Methods

Extension functions in `map_extensions/` use top-level function syntax (Haxe 4+):

```haxe
package dropecho.dungen.map_extensions;

import dropecho.dungen.Map2d;

function myExtension(map:Map2d, arg:Int):Array<Tile2d> {
  // map is the implicit `this`
}
```

The function is then declared in `Map2d.hx` via `@:using(dropecho.dungen.map_extensions.MyExt)`.

## RNG

Always use `seedyrng.Random`. Seeds are `String` typed. Initialize with `random.setStringSeed(seed)`.

## Inline

Use `inline` on:
- Pure coordinate math (`XYtoIndex`, `indexToXY`, `tileToIndex`)
- Simple getters and delegating iterators

Avoid `inline` on methods with non-trivial logic or that may need override.

## Comments

Only comment the WHY when non-obvious. No docblocks on implementations beyond the
existing JSDoc on `Map2d` public methods. `@ignoreInstrument` on all debug/pretty-print methods.

## Package Structure

```
package dropecho.dungen;            # Map2d, Tile2d, Pattern
package dropecho.dungen.bsp;        # BSPBuilder, BSPData
package dropecho.dungen.generators; # all generators
package dropecho.dungen.map_extensions; # extension functions
package dropecho.dungen.regions;    # RegionMap, RegionManager, Region
package dropecho.dungen.regions.extensions; # region extension functions
package dropecho.dungen.export;     # TiledExporter
```

## Build Targets

- `targets/js.hxml` — CommonJS output to `dist/js/cjs/`
- `targets/js-esm.hxml` — ESM output to `dist/js/esm/`
- C# and Python targets exist in `build.hxml` but are commented out

## Error Handling

No defensive error handling for internal invariants. Only validate at system boundaries.
Generators silently produce empty/degenerate maps for invalid configs rather than throwing.
