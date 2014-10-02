gulp = require('gulp')
coffee = require('gulp-coffee')
gutil = require('gulp-util')
concat = require('gulp-concat')
stylus = require('gulp-stylus')
uglify = require('gulp-uglify')
cssmin = require('gulp-minify-css')
watch = require('gulp-watch')
include = require('gulp-include')
gulpif = require('gulp-if')

nib = require('nib')

gulp.task 'coffee', ->
  gulp.src(paths.js)
    .pipe(include())
    .pipe gulpif(/[.]coffee$/, coffee().on('error', gutil.log))
    .pipe(concat('all.js'))
    .pipe(uglify())
    .pipe(gulp.dest(paths.build + 'js/'))

gulp.task 'styles', ->
  gulp.src(paths.styles)
    .pipe(stylus(
      use: nib()
      compress: true
      linenos: true
    ))
    .pipe(concat('app.css'))
    .pipe(cssmin())
    .pipe(gulp.dest(paths.build + 'css/'))

gulp.task 'fonts', ->
  gulp.src(external.fonts.concat(paths.fonts))
    .pipe(gulp.dest(paths.build + 'fonts/'))

gulp.task 'images', ->
  gulp.src(external.images.concat(paths.images))
    .pipe(gulp.dest(paths.build + 'images/'))

paths =
  coffee: './src/js/*.coffee',
  stylus: './src/styles/**/*.styl'
  build: './static/'
  fonts: './src/fonts/**/*'
  images: './src/images/**/*'

external =
  styles: [
    "bower_components/semantic-grid/stylesheets/reset.css"
    "bower_components/semantic-grid/stylesheets/styl/grid.styl"
  ]
  fonts: []
  images: []
  js: [
    "bower_components/zepto/zepto.js"
  ]

paths.styles = external.styles.concat(paths.stylus)
paths.js = external.js.concat(paths.coffee)

gulp.task('default', ['coffee', 'styles', 'fonts', 'images'])

gulp.task 'watch', ->
  watch paths.js, ->
    gulp.start 'coffee'
  watch paths.styles, ->
    gulp.start 'styles'
  watch paths.images, ->
    gulp.start 'images'
