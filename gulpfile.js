'use strict';
var gulp = require('gulp');
var shell = require('gulp-shell');
var mkdirp = require('mkdirp');

function createArtifactDirs() {
    mkdirp('artifacts/js');
    mkdirp('artifacts/test');
}

function watch() {
    var watchDirs = ['src/**/*.hx', 'test/**/*.hx', 'targets/**'];
    gulp.watch(watchDirs, ['test']);
}

gulp.task('create-artifacts-dir', createArtifactDirs);
gulp.task('build-js', shell.task('haxe targets/js.hxml'));
gulp.task('test', shell.task('haxelib run munit test -result-exit-code'));
gulp.task('test-coverage', shell.task('haxelib run munit test -coverage -result-exit-code'));

gulp.task('watch', watch);

gulp.task('build', ['create-artifacts-dir', 'build-js']);
gulp.task('ci', ['test-coverage', 'build']);
gulp.task('default', ['ci']);
