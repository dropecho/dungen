var dungen = require('./dungen').dungen;


var foo = new dungen.BSPGenerator({ width : 32, height :32 });
console.log(foo.width);
console.log(foo.height);

var bar = dungen.CAGenerator.generate({ width : 64, height:32 });
console.log(bar._width);
console.log(bar._height);

console.log(bar.toString());


