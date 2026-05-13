import * as dungen from './dropecho.dungen/index.js';

const ctx = document.querySelector('#canvas').getContext('2d');
const convChainCtx = document.querySelector('#cccanvas').getContext('2d');
const timeDiv = document.querySelector('#time');

const colors = ['#333', '#aaa'];

const bsp = new dungen.BSPBuilder({
  height: 128,
  width: 128,
});

const roomGenParams = {
  padding: 0,
};

const caveGenParams = {
  steps: [
    {
      reps: 4,
      r1_cutoff: 5,
      r2_cutoff: 2,
      invert: true,
    },
    {
      reps: 3,
      r1_cutoff: 5,
      r2_cutoff: 0,
      invert: true,
    },
  ],
  height: 128,
  width: 128,
  tile_floor: 1,
  tile_wall: 0,
  start_fill_percent: 62,
  useOtherType: false,
};

const convChainParams = {
  width: 128,
  height: 128,
  n: 3,
  temperature: 1,
  iterations: 20,
};

const regionParams = {
  depth: 2,
  expand: false,
};

const opts = {
  type: 'room',
  seed: '0',
  mapScale: 10,
  generateNewSeed: function () {
    opts.seed = Math.round(Math.random() * 99999999).toString();
    this.generate();
  },

  generateConvChainNewSeed: function () {
    this.generateConvChain(Math.round(Math.random() * 99999999).toString());
  },

  generateConvChain: (seed = '0') => {
    convChainCtx.clearRect(0, 0, 1024, 1024);

    const gen = new dungen.ConvChain(map);
    gen.rng.setStringSeed(seed);
    const convChainMap = gen.generate(
      convChainParams.width,
      convChainParams.height,
      convChainParams.n,
      convChainParams.temperature,
      convChainParams.iterations,
    );

    convChainMap._mapData.forEach((tile, i) => {
      const pos = convChainMap.indexToXY(i);
      convChainCtx.fillStyle = tile === 0 ? '#333' : '#aaa';
      convChainCtx.fillRect(
        pos.x * opts.mapScale,
        pos.y * opts.mapScale,
        opts.mapScale,
        opts.mapScale,
      );
    });
  },

  generate: () => {
    let map;
    const start = performance.now();
    switch (opts.type) {
      case 'cave':
        caveGenParams.seed = opts.seed;
        map = dungen.CAGenerator.generate(caveGenParams);
        break;
      case 'walk':
        caveGenParams.seed = opts.seed;
        map = dungen.WalkGenerator.generate(caveGenParams);
        break;
      case 'random':
        caveGenParams.seed = opts.seed;
        map = dungen.RandomGenerator.generate(caveGenParams);
        break;
      case 'mixed':
        bsp.seed = opts.seed;
        map = dungen.MixedGenerator.buildRooms(bsp.generate(), roomGenParams);
        break;
      case 'room':
        bsp.seed = opts.seed;
        map = dungen.RoomGenerator.buildRooms(bsp.generate(), roomGenParams);
        break;
    }
    const end = performance.now();
    const time = end - start;

    timeDiv.innerHTML = `generation time in ms: ${time.toFixed(2)}`;

    convChainCtx.clearRect(0, 0, 1024, 1024);
    ctx.clearRect(0, 0, 1024, 1024);

    map._mapData.forEach((tile, i) => {
      const pos = map.indexToXY(i);
      ctx.fillStyle = colors[tile];
      ctx.fillRect(pos.x * opts.mapScale, pos.y * opts.mapScale, opts.mapScale, opts.mapScale);
    });
  },

  generateRegions: () => {
    const start = performance.now();
    const regionmap = new dungen.RegionMap(map, regionParams.depth, regionParams.expand);
    const end = performance.now();
    const time = end - start;

    timeDiv.innerHTML = `generation time in ms: ${time.toFixed(2)}`;

    const regionColors = [...colors];
    for (let i = 0; i < 256; i++) {
      regionColors.push(`#${Math.random().toString(16).substr(2, 6)}`);
    }

    regionmap._mapData.forEach((tile, i) => {
      const pos = map.indexToXY(i);
      ctx.fillStyle = regionColors[tile];
      ctx.fillRect(pos.x * opts.mapScale, pos.y * opts.mapScale, opts.mapScale, opts.mapScale);
    });
  },
  generateJson: () => {
    const json = dungen.TiledExporter.export(map);
    document.querySelector('#json').value = json;
  },
};

const gui = new dat.GUI();
const optsTypeController = gui.add(opts, 'type', ['room', 'cave', 'walk', 'random', 'mixed']);
gui.add(opts, 'seed', '0').listen();
gui.add(opts, 'mapScale', 2, 16).step(1);
const colorsGui = gui.addFolder('colors');
colorsGui.addColor(colors, '0').name('wall');
colorsGui.addColor(colors, '1').name('walkable');

function addRoomGui() {
  const roomGui = gui.addFolder('room');
  roomGui.add(bsp, 'width', 16, 2048).step(1);
  roomGui.add(bsp, 'height', 16, 2048).step(1);
  roomGui.add(bsp, 'minWidth', 2, 32).step(1);
  roomGui.add(bsp, 'minHeight', 2, 32).step(1);
  roomGui.add(bsp, 'depth', 1, 10).step(1);
  roomGui.add(bsp, 'ratio', 0, 1).step(0.1);
  roomGui.add(roomGenParams, 'padding', 0, 16).step(1);
  //   roomGui.hide();
  return roomGui;
}

function addCaveGui() {
  const caveGui = gui.addFolder('cave');
  caveGui.add(caveGenParams, 'width', 16, 512);
  caveGui.add(caveGenParams, 'height', 16, 512);
  caveGui.add(caveGenParams, 'start_fill_percent', 0, 100).step(1);
  caveGui.add(caveGenParams, 'useOtherType');

  const step1 = caveGui.addFolder('step1');
  step1.add(caveGenParams.steps[0], 'reps', 1, 10).step(1);
  step1.add(caveGenParams.steps[0], 'r1_cutoff', 0, 10).step(1);
  step1.add(caveGenParams.steps[0], 'r2_cutoff', 0, 10).step(1);
  step1.add(caveGenParams.steps[0], 'invert');

  const step2 = caveGui.addFolder('step2');
  step2.add(caveGenParams.steps[1], 'reps', 1, 10).step(1);
  step2.add(caveGenParams.steps[1], 'r1_cutoff', 0, 10).step(1);
  step2.add(caveGenParams.steps[1], 'r2_cutoff', 0, 10).step(1);
  step2.add(caveGenParams.steps[1], 'invert');
  caveGui.hide();

  return caveGui;
}

const roomGui = addRoomGui();
const caveGui = addCaveGui();
optsTypeController.onChange((newValue) => {
  switch (newValue) {
    case 'room':
      roomGui.show();
      roomGui.open();
      caveGui.hide();
      break;
    case 'cave':
      caveGui.show();
      caveGui.open();
      roomGui.hide();
      break;
    case 'walk':
      caveGui.hide();
      roomGui.hide();
      break;
    case 'random':
      caveGui.hide();
      roomGui.hide();
      break;
    case 'mixed':
      roomGui.show();
      caveGui.show();
      break;
  }
});

gui.add(opts, 'generate');
gui.add(opts, 'generateNewSeed');

const regiongui = gui.addFolder('Regions');
regiongui.add(regionParams, 'depth', 1, 10).step(1);
regiongui.add(regionParams, 'expand');
gui.add(opts, 'generateRegions');
