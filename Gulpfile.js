'use strict';
var gulp = require('gulp');
var shell = require('gulp-shell');
var mkdirp = require('mkdirp');

var watching = false;

gulp.on('err', function errHandler(err) {
    process.emit('exit', err.err);
});

process.on('exit', function(err) {
    process.nextTick(function() {
		if(!watching){
        	process.exit(err.code);
		}
    });
});

gulp.task('create-artifacts-dir', function() {
    mkdirp('artifacts/js');
    mkdirp('artifacts/test');
});

gulp.task('build-js', shell.task('haxe targets/js.hxml'));

gulp.task('build', ['create-artifacts-dir', 'build-js']);

gulp.task('test', function() {
    return gulp
        .src('')
        .pipe(shell('haxelib run munit test -result-exit-code'));
});

gulp.task('test-coverage', shell.task('haxelib run munit test -coverage'));

gulp.task('watch', function() {
	watching = true;
    gulp.watch(['src/**/*.hx', 'test/**/*.hx', 'targets/**'], ['test']);
});
