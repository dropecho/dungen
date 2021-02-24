var map;
var bsp = new dungen.BSPGenerator({
  height: 64,
  width: 64
});
var ctx = document.querySelector('#canvas').getContext('2d');
var convChainMap;
var convChainCtx = document.querySelector('#cccanvas').getContext('2d');
var roomGenParams = {
  padding: 0
};
var caveGenParams = {
  steps: [{
    reps: 4,
    r1_cutoff: 5,
    r2_cutoff: 2,
    invert: true
  },
  {
    reps: 3,
    r1_cutoff: 5,
    r2_cutoff: 0,
    invert: true
  }
  ],
  height: 64,
  width: 64,
  tile_floor: 1,
  tile_wall: 0,
  start_fill_percent: 62,
  useOtherType: false
};

var convChainParams = {
  width: 64,
  height: 64,
  n: 3,
  temperature: 1,
  iterations: 20
};

var regionParams = {
  depth: 2,
  expand: false
};

var opts = {
  type: 'room',
  seed: '0',
  mapScale: 10,
  generateNewSeed: function() {
    opts.seed = Math.round(Math.random() * 99999999).toString();
    this.generate();
  },

  generateConvChainNewSeed: function() {
    this.generateConvChain(Math.round(Math.random() * 99999999).toString());
  },

  generateConvChain: function(seed = '0') {
    convChainCtx.clearRect(0, 0, 1024, 1024);

    var gen = new dungen.ConvChain(map);
    gen.rng.setStringSeed(seed);
    var convChainMap = gen.generate(
      convChainParams.width,
      convChainParams.height,
      convChainParams.n,
      convChainParams.temperature,
      convChainParams.iterations,
    );

    console.log('what', convChainMap);

    convChainMap._mapData.forEach(function(tile, i) {
      var pos = convChainMap.IndexToXY(i);
      convChainCtx.fillStyle = tile == 0 ? '#333' : '#aaa';
      convChainCtx.fillRect(pos.x * opts.mapScale, pos.y * opts.mapScale, opts.mapScale, opts.mapScale);
    });
  },

  generate: function() {
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
    convChainCtx.clearRect(0, 0, 1024, 1024);
    ctx.clearRect(0, 0, 1024, 1024);

    map._mapData.forEach(function(tile, i) {
      var pos = map.IndexToXY(i);
      ctx.fillStyle = tile == 0 ? '#333' : '#aaa';
      ctx.fillRect(pos.x * opts.mapScale, pos.y * opts.mapScale, opts.mapScale, opts.mapScale);
    });
  },

  generateRegions: function() {
    var regionmap = new dungen.RegionMap(map, regionParams.depth, regionParams.expand);

    var colors = ['#222', '#fff'];
    for (var i = 0; i < 256; i++) {
      colors.push('#' + Math.random().toString(16).substr(2, 6));
    }

    regionmap._mapData.forEach(function(tile, i) {
      var pos = map.IndexToXY(i);
      ctx.fillStyle = colors[tile];
      ctx.fillRect(pos.x * opts.mapScale, pos.y * opts.mapScale, opts.mapScale, opts.mapScale);
    });

  },
  generateJson: function() {
    var json = dungen.TiledExporter.export(map);
    document.querySelector('#json').value = json;
  }
};

var gui = new dat.GUI();
gui.add(opts, 'type', ['room', 'cave', 'walk', 'random', 'mixed']);
gui.add(opts, 'seed', '0').listen();
gui.add(opts, 'mapScale', 2, 16).step(1);

(function addRoomGui() {
  var roomGui = gui.addFolder('room');
  roomGui.add(bsp, 'width', 16, 128).step(1);
  roomGui.add(bsp, 'height', 16, 128).step(1);
  roomGui.add(bsp, 'minWidth', 2, 32).step(1);
  roomGui.add(bsp, 'minHeight', 2, 32).step(1);
  roomGui.add(bsp, 'depth', 1, 10).step(1);
  roomGui.add(bsp, 'ratio', 0, 1).step(0.1);
  roomGui.add(roomGenParams, 'padding', 0, 16).step(1);
})();

(function addCaveGui() {
  var caveGui = gui.addFolder('cave');
  caveGui.add(caveGenParams, 'width', 16, 128);
  caveGui.add(caveGenParams, 'height', 16, 128);
  caveGui.add(caveGenParams, 'start_fill_percent', 0, 100).step(1);
  caveGui.add(caveGenParams, 'useOtherType');

  var step1 = caveGui.addFolder('step1');
  step1.add(caveGenParams.steps[0], 'reps', 1, 10).step(1);
  step1.add(caveGenParams.steps[0], 'r1_cutoff', 0, 10).step(1);
  step1.add(caveGenParams.steps[0], 'r2_cutoff', 0, 10).step(1);
  step1.add(caveGenParams.steps[0], 'invert');

  var step2 = caveGui.addFolder('step2');
  step2.add(caveGenParams.steps[1], 'reps', 1, 10).step(1);
  step2.add(caveGenParams.steps[1], 'r1_cutoff', 0, 10).step(1);
  step2.add(caveGenParams.steps[1], 'r2_cutoff', 0, 10).step(1);
  step2.add(caveGenParams.steps[1], 'invert');
})();
gui.add(opts, 'generate');
gui.add(opts, 'generateNewSeed');

var convchaingui = gui.addFolder('ConvChain');
convchaingui.add(convChainParams, 'width', 16, 128);
convchaingui.add(convChainParams, 'height', 16, 128);
convchaingui.add(convChainParams, 'n', 2, 8).step(1);

gui.add(opts, 'generateConvChain');
gui.add(opts, 'generateConvChainNewSeed');

var regiongui = gui.addFolder('Regions');
regiongui.add(regionParams, 'depth', 1, 10).step(1);
regiongui.add(regionParams, 'expand');
gui.add(opts, 'generateRegions');
gui.add(opts, 'generateJson');


