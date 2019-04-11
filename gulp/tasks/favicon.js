/*jslint node: true */

module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('favicon', function () {
        return gulp.src(current_config.faviconPath)
            .pipe(gulp.dest(current_config.distDir + '/'))
            .pipe(plugins.browserSync.stream());
    });
};
