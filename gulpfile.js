var gulp = require('gulp');
var minifyHTML = require('gulp-minify-html');
var minifyCss = require('gulp-minify-css');
var runSequence = require('run-sequence');

 gulp.task('build:jekyll', function (gulpCallBack) {
     var spawn = require('child_process').spawn;
     var jekyll = spawn('jekyll', ['build', '--drafts'], {stdio: 'inherit'});
 
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

gulp.task('default', function(callback) {
    runSequence('build:jekyll', ['minify:html', 'minify:css'], 'deploy:dev', callback);
    //TODO: delete _site folder
});