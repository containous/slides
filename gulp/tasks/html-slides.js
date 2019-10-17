/*jslint node: true */

module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('html', function () {
        return gulp.src(current_config.sourcesDir + '/**/*.adoc', {read: false})
            .on('end', function () {
                plugins.asciidoctor.convertFile(
                    current_config.sourcesDir + '/index.adoc',
                    {
                        safe: 'unsafe',
                        backend: 'revealjs',
                        attributes: {
                            'docinfosPath': current_config.docinfosPath,
                            'presentationUrl': process.env.PRESENTATION_URL,
                            'repositoryUrl': process.env.REPOSITORY_URL,
                            'revealjs_plugins': current_config.revealJSPluginList,
                            'revealjs_plugins_configuration': current_config.scriptsSrcPath + '/revealjs-plugins-config.js'
                        },
                        to_dir: current_config.distDir,
                    }
                );
            })
            .pipe(plugins.browserSync.stream());
    });
};
