var gulp = require('gulp');
var minifyHTML = require('gulp-minify-html');
var minifyCss = require('gulp-minify-css');
var rsync = require('gulp-rsync');
var env = require('gulp-env');
var rev = require('gulp-rev');
var revCollector = require('gulp-rev-collector');
var runSequence = require('run-sequence');

var environment = 'development';

gulp.task('build:jekyll', function (gulpCallBack) {
    var spawn = require('child_process').spawn;
    if(environment == 'production') {
        var jekyll = spawn('jekyll', ['build'], { stdio: 'inherit' });
    } else if(environment == 'development') {
        var jekyll = spawn('jekyll', ['build', '--drafts'], {stdio: 'inherit'}); // Build with drafts only in dev env
    } else {
        throw 'Unknown environment';
    }

    jekyll.on('exit', function (code) {
        gulpCallBack(code === 0 ? null : 'ERROR: Jekyll process exited with code: ' + code);
    });
});

gulp.task('serve', function() {
    var spawn = require('child_process').spawn;
    spawn('jekyll', ['serve', '--drafts', '--watch'], { stdio: 'inherit' });
});

gulp.task('minify:html', function () {
    var opts = {
        conditionals: true,
        spare: true,
        empty: true
    };

    return gulp.src('./_site/**/*.html')
        .pipe(minifyHTML(opts))
        .pipe(gulp.dest('./_site/'));
});

gulp.task('minify:css', function () {

    return gulp.src('./_site/assets/css/*.css')
        .pipe(minifyCss())
        .pipe(gulp.dest('./_site/assets/css/'));
});

gulp.task('deploy:dev', function () {

    // return gulp.src(['./_site/**/*'], { dot: true })
    //     .pipe(gulp.dest('../lescinskas.test/'));
});

gulp.task('deploy:prod', function () {

    return gulp.src(['./_site/**/*'], { dot: true })
        .pipe(rsync({
            root: '_site',
            hostname: 'lescinskas.lt',
            destination: '~/lescinskas.lt/data',
            incremental: true
        }));
});

gulp.task('setenv:production', function() {
    environment = 'production';
    env({
        vars: {
            "JEKYLL_ENV": "production"
        }
    });
});

/**
 * Should be run after build and before minification
 */
gulp.task('revision', function() {
    return gulp.src(['./assets/**/*.{css,js}'])
        .pipe(rev())
        .pipe(gulp.dest('./_site/assets/'))
        .pipe(rev.manifest({ path: 'manifest.json'}))
        .pipe(gulp.dest('./_site/assets/'));
});
/**
 * Should be run after minification
 */
gulp.task('revision:collect', function() {
    return gulp.src(['./_site/assets/manifest.json', './_site/**/*.html'])
        .pipe(revCollector())
        .pipe(gulp.dest('./_site'));
});

gulp.task('default', function (callback) {
    runSequence(/*'build:jekyll', */'revision', ['minify:html', 'minify:css'], 'revision:collect', 'deploy:dev', callback);
    //@TODO: delete _site folder
});

gulp.task('release', function (callback) {
    runSequence('setenv:production', /*'build:jekyll',*/ 'revision', ['minify:html', 'minify:css'], 'revision:collect', 'deploy:prod', callback);
    //@TODO: delete _site folder
});
