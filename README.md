# dropecho.dungen

A procedural generation toolkit for games — map generators, a `Map2d` grid with a rich set of
map extensions, and exporters. Written in Haxe, compiled to multiple targets and published to
both **haxelib** and **npm**.

## Features

- **Generators** — cellular automata, WFC, BSP, tunneler, rooms, village, walk, and more.
- **`Map2d`** — a 2D tile grid with extensions for flood fill, BFS, connectivity checks,
  region management, Bresenham lines, find-and-replace, distance fields, and more.
- **Exporters** — e.g. Tiled (`TiledExporter`).

## Targets

| Target | Output | Status |
|---|---|---|
| JS (CommonJS) | `dist/js/cjs/index.cjs` | on by default |
| JS (ES module + `.d.ts`) | `dist/js/esm/index.js` | on by default |
| C# (DLL) | `dist/cs/dropecho.dungen` | commented in `build.hxml` |
| Python | `dist/python/dungen.py` | commented in `build.hxml` |
| API docs (dox XML) | `artifacts/docs.xml` | commented in `build.hxml` |

## Develop

Dependencies resolve through **lix** (`.haxerc` + `haxe_libraries/`); `npm install` runs
`lix download` to fetch them.

```bash
npm install     # lix download — fetch pinned Haxe dependencies
npm run build   # build the enabled targets (haxe build.hxml)
npm test        # run the utest suite via dropecho.testing
npm run clean   # remove dist/ and artifacts/
```

- Build options are split into shared settings (top of `build.hxml`) and one hxml per target
  under `targets/`. Enable a target by uncommenting its `--next targets/<name>.hxml` pair.
- Tests are auto-discovered: every `test/**/*Tests.hx` class that `extends utest.Test` is
  registered by `dropecho.testing` — there is no test main to maintain.

## JavaScript output

The CommonJS and ESM builds are wired up through `package.json` `exports`, so the package
works for both `require` and `import`. The ESM build also emits `.d.ts` typings via genes.

## Releases

Releases are automated with `semantic-release` (see `.releaserc.json`): commits drive the
version bump, and the package is published to npm and haxelib with a generated changelog.

## License

MIT
