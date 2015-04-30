gulp = require 'gulp'
browserSync = require('browser-sync').create()
reload = browserSync.reload

gulpDeps = ['watch', 'coffee', 'jade', 'stylus', 'sourcemaps']

gulpDeps.forEach (dep) -> eval "#{dep} = require('gulp-#{dep}')" # require each dep



gulp.task 'default', ['watch', 'browser-sync']

gulp.task 'watch', ['watch-coffee', 'watch-jade', 'watch-stylus']

gulp.task 'watch-coffee', ->
    gulp.src 'src/**/*.coffee'
        .pipe watch 'src/**/*.coffee'
        .pipe sourcemaps.init()
        .pipe coffee()
        .pipe sourcemaps.write()
        .pipe gulp.dest 'build'
        .pipe reload stream: true

gulp.task 'watch-jade', ->
    gulp.src 'src/**/*.jade'
        .pipe watch 'src/**/*.jade'
        .pipe jade(pretty: true)
        .pipe gulp.dest 'build'
        .pipe reload stream: true

gulp.task 'watch-stylus', ->
    gulp.src 'src/**/*.styl'
        .pipe watch 'src/**/*.styl'
        .pipe sourcemaps.init()
        .pipe stylus()
        .pipe sourcemaps.write()
        .pipe gulp.dest 'build'
        .pipe reload stream: true

gulp.task 'browser-sync', ->
    browserSync.init
        server:
            baseDir: 'build'
