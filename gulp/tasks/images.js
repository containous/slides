/*jslint node: true */
module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('images', function () {

        var specificImages = gulp.src(current_config.imgSrcPath + '/*')
            .pipe(gulp.dest(current_config.distDir + '/images/')),
            styleImages = gulp.src(current_config.stylesSrcPath + '/images/*')
            .pipe(gulp.dest(current_config.distDir + '/images/'));

        return plugins.mergeStreams(specificImages, styleImages)
            .pipe(plugins.browserSync.stream());
    });
};
