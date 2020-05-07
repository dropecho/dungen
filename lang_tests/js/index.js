var dungen = require('./dropecho.dungen').dungen;


// var foo = new dungen.BSPGenerator({ width : 32, height :32 });
// console.log(foo.width);
// console.log(foo.height);
//
// var bar = dungen.CAGenerator.generate({ width : 64, height:32 });
// console.log(bar._width);
// console.log(bar._height);

// console.log(bar.toString());

var sample = new dungen.Map2d(8, 8);
sample._mapData = [
  0, 0, 0, 0, 0, 0, 0, 0,
  1, 1, 1, 1, 1, 1, 1, 1,
  0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0,
  1, 1, 1, 1, 1, 1, 1, 1,
  0, 0, 0, 0, 0, 0, 0, 0
];

console.log(sample.toString());


var foo = new dungen.ConvChain(sample);
var map = foo.generate(16, 16, 3, 1, 10);

console.log(map.toString());


