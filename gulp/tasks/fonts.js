/*jslint node: true */

module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('fonts', function () {
        return gulp.src([current_config.fontSrcPath + '/*'])
            .pipe(gulp.dest(current_config.distDir + '/styles/fonts/'))
            .pipe(plugins.browserSync.stream());
    });
};
