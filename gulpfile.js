var gulp = require('gulp');
var minifyHTML = require('gulp-minify-html');
var minifyCss = require('gulp-minify-css');
var rsync = require('gulp-rsync');
var runSequence = require('run-sequence');

 gulp.task('build:jekyll', function (gulpCallBack) {
     var spawn = require('child_process').spawn;
     var jekyll = spawn('jekyll', ['build'], {stdio: 'inherit'});
     //var jekyll = spawn('jekyll', ['build', '--drafts'], {stdio: 'inherit'}); // @TODO Build with drafts only in dev mode
 
     jekyll.on('exit', function(code) {
         gulpCallBack(code === 0 ? null : 'ERROR: Jekyll process exited with code: '+code);
     });
 });

gulp.task('minify:html', function() {
  var opts = {
    conditionals: true,
    spare:true,
  };
 
  return gulp.src('./_site/**/*.html')
    .pipe(minifyHTML(opts))
    .pipe(gulp.dest('./_site/'));
});

gulp.task('minify:css', function() {

  return gulp.src('./_site/assets/css/custom.css')
    .pipe(minifyCss())
    .pipe(gulp.dest('./_site/assets/css/'));
});

gulp.task('deploy:dev',  function() {

    return gulp.src(['./_site/**/*'], {dot: true})
        .pipe(gulp.dest('../lescinskas.local/'));
});

gulp.task('deploy:prod',  function() {

    return gulp.src(['./_site/**/*'], {dot: true})
        .pipe(rsync({
            root: '_site',
            hostname: 'lescinskas.lt',
            destination: '~/lescinskas.lt/data'
        }));
});

gulp.task('default', function(callback) {
    runSequence('build:jekyll', ['minify:html', 'minify:css'], 'deploy:dev', callback);
    //@TODO: delete _site folder
});

gulp.task('release', function(callback) {
    runSequence('build:jekyll', ['minify:html', 'minify:css'], 'deploy:prod', callback);
    //@TODO: delete _site folder
});