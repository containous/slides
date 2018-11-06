/*jslint node: true, stupid: true */
module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('images', function () {

        // We merge the "training-commons" and training's specific images on a temp dir
        var specificImages = gulp.src(current_config.imgSrcPath + '/*')
            .pipe(gulp.dest(current_config.distDir + '/images/')),
            styleImages = gulp.src(current_config.stylesSrcPath + '/images/*')
            .pipe(gulp.dest(current_config.distDir + '/images/'));

        return plugins.mergeStreams(specificImages, styleImages)
            .pipe(plugins.browserSync.stream());
    });
};
