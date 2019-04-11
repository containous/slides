/*jslint node: true */
module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('videos', function () {
        return gulp.src(current_config.videosSrcPath + '/*')
            .pipe(gulp.dest(current_config.distDir + '/videos/'));
    });
};
