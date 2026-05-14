# Testing Guide

## Running Tests

```bash
haxelib run dropecho.testing
# or
npm test
```

Compiles to `artifacts/js_test.cjs` (JS) then runs via Node.js.

---

## Test Framework

- **Test runner:** `dropecho.testing` (latest available)
- **Assertion library:** `utest` (`utest.Assert`, `utest.Test`)
- **Discovery:** Any file ending in `Tests.hx` under `test/` is auto-included
- **Test methods:** Must be prefixed `test_` to be picked up by utest
- **Coverage:** `instrument` library; output to `artifacts/lcov.info`

### Test Class Pattern

```haxe
package map;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class Map2dTests extends Test {
    var subject:Map2d;

    public function setup() {
        subject = new Map2d(10, 10);
    }

    public function test_canInstantiate() {
        Assert.notNull(subject);
    }

    public function test_get_set() {
        subject.set(1, 1, 5);
        Assert.equals(5, subject.get(1, 1));
    }
}
```

---

## Common Assertions

```haxe
Assert.equals(expected, actual);
Assert.notEquals(a, b);
Assert.isTrue(expr);
Assert.isFalse(expr);
Assert.notNull(x);
Assert.isNull(x);
Assert.same(a, b);          // structural equality
Assert.contains(item, arr); // array contains
```

---

## Coverage

Coverage is configured in `test.hxml`:

```hxml
-lib instrument
--macro instrument.Instrumentation.coverage([], ['src'], [])
-D coverage-console-file-summary-reporter
-D coverage-lcov-reporter=artifacts/lcov.info
```

Methods annotated with `@ignoreInstrument` are excluded (used on `toPrettyString`, `toString`,
and other debug output methods).

---

## Test File Locations

```
test/
  bsp/
    BSPBuilderTests.hx
    NodeTests.hx
  export/
    TiledExporterTests.hx
  generators/
    WFCTests.hx
  map/
    Map2dTests.hx
    PatternTests.hx
    RegionMapTests.hx
    TileIteratorTests.hx
    extensions/
      BFSTests.hx
      BresenhamLineTests.hx
      CheckConnectivityTests.hx
      DistanceFillTests.hx
      FindAndReplaceTests.hx
      FloodFillTests.hx
      GetFirstTileOfTypeTests.hx
      NeighborsTests.hx
      RectTests.hx
      RegionFillTests.hx
      RegionManagerTests.hx
```

---

## Known Gaps

- Most generators (CA, Cellular, Maze, Room, Tunneler, Village, Walk) have no unit tests
- `WFCTests` exists but coverage of edge cases is limited
- `RegionMapTests` covers basic construction; `expandRegionsByOne` / `fillAlcoves` paths untested
- `TiledExporter` tests exist but export format validation may be shallow
