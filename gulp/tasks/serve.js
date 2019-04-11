/*jslint node: true */
module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('serve', function (done) {
        plugins.browserSync.init({
            server: current_config.distDir,
            open: false,
            ui: false,
            host: current_config.listen_ip,
            port: current_config.listen_port,
        });

        return done();
    });
};
