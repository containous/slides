/*jslint node: true */
module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('clean', function (done) {
        plugins.exec('rm -rf ' + current_config.distDir + '/*');
        return done();
    });
};
