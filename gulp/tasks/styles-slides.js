/*jslint node: true */
module.exports = function (gulp, plugins, current_config) {
    'use strict';

    gulp.task('styles', function () {
        return gulp.src(current_config.stylesSrcPath + '/*.scss')
            .pipe(plugins.sass().on('error', plugins.sass.logError))
            .pipe(plugins.rename('build.css'))
            .pipe(plugins.autoprefixer())
            .pipe(plugins.csso())
            .pipe(gulp.dest(current_config.distDir + '/styles/'))
            .pipe(plugins.browserSync.stream());
    });
};
