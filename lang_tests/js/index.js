var dungen = require('./dropecho.dungen').dungen;


// var foo = new dungen.BSPGenerator({ width : 32, height :32 });
// console.log(foo.width);
// console.log(foo.height);
//
// var bar = dungen.CAGenerator.generate({ width : 64, height:32 });
// console.log(bar._width);
// console.log(bar._height);

// console.log(bar.toString());
var start = Date.now();

// var sample = new dungen.Map2d(5, 5);
// sample._mapData = [
//   1, 1, 0, 1, 1,
//   1, 0, 0, 0, 1,
//   0, 0, 0, 0, 0,
//   1, 0, 0, 0, 1,
//   1, 1, 0, 1, 1,
// ];
// var sample = new dungen.Map2d(3, 3);
// sample._mapData = [
//   1, 0, 1,
//   0, 0, 0,
//   1, 0, 1,
// ];
var sample = new dungen.Map2d(4, 4);
sample._mapData = [
  0, 0, 0, 0,
  0, 1, 1, 1,
  0, 1, 0, 1,
  0, 1, 1, 1,
];


console.log(sample.toString());
console.log('took: ' + (Date.now() - start));

start = Date.now();
var gen = new dungen.ConvChain(sample);
var map = gen.generate(80, 40, 2, 1, 25);

console.log(map.toString());
console.log('took: ' + (Date.now() - start));

// start = Date.now();
// map = gen.generate(80, 40, 3, 1, 2);
// console.log(map.toString());
// console.log('took: ' + (Date.now() - start));

