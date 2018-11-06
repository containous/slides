/*jslint node: true, stupid: true */
module.exports = function (gulp, plugins, current_config) {
    'use strict';
    gulp.task('pdf-generate', function () {
        return gulp.src([current_config.slidesEntrypointPath])
            .pipe(plugins.exec(current_config.get_asciidoctor_revealjs_html_command(
                '<%= file.path %>',
                current_config.distDir + '/pdf-<%= file.stem %>.html',
                ' -a disable-toc-icon '
            ), {
                pipeStdout: false
            }))
            .pipe(plugins.exec.reporter())
            .pipe(plugins.exec(current_config.get_asciidoctor_revealjs_pdf_from_html_command(
                current_config.distDir + '/pdf-<%= file.stem %>.html',
                current_config.distDir + '/<%= file.stem %>.pdf'
            ), {
                pipeStdout: false
            }))
            .pipe(plugins.exec.reporter())
            .pipe(plugins.exec('rm -f ' + current_config.distDir + '/pdf-<%= file.stem %>.html', {
                pipeStdout: false
            }))
            .pipe(plugins.exec.reporter());
    });
};
// current_config.get_asciidoctor_revealjs_pdf_from_html_command = function (source, destination) {
//     return 'docker run --read-only' +
//     ' --volumes-from $(hostname)' +
//     ' astefanutti/decktape:1.0.0 "' + source + '"' +
//     ' "' + destination + '"';
// };
