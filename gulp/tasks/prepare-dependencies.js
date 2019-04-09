/*jslint node: true, stupid: true */
module.exports = function (gulp, plugins, current_config) {
    'use strict';
    ////////////////////////// Managing Our ToC with custom tocify script and its deps
    gulp.task('prepare:revealjs', function () {
        var baseRevealJSPath = current_config.nodeModulesDir + '/reveal.js',
            revealJsDestDir = current_config.distDir + '/reveal.js',
            mainRevealCss = gulp.src(baseRevealJSPath + '/css/reveal.css')
                .pipe(gulp.dest(revealJsDestDir + '/css/')),
            paperCSS = gulp.src(baseRevealJSPath + '/css/print/paper.css')
                .pipe(gulp.dest(revealJsDestDir + '/css/print')),
            mainRevealJs = gulp.src(baseRevealJSPath + '/js/reveal.js')
                .pipe(gulp.dest(revealJsDestDir + '/js/')),
            zenBurnCss = gulp.src(baseRevealJSPath + '/lib/css/zenburn.css')
                .pipe(gulp.dest(revealJsDestDir + '/lib/css/')),
            notesJs = gulp.src(baseRevealJSPath + '/plugin/notes/notes.js')
                .pipe(gulp.dest(revealJsDestDir + '/plugin/notes/')),
            markedJs = gulp.src(baseRevealJSPath + '/plugin/markdown/marked.js')
                .pipe(gulp.dest(revealJsDestDir + '/plugin/markdown/')),
            notesHtml = gulp.src(baseRevealJSPath + '/plugin/notes/notes.html')
                .pipe(gulp.dest(revealJsDestDir + '/plugin/notes/')),
            zoomJs = gulp.src(baseRevealJSPath + '/plugin/zoom-js/zoom.js')
                .pipe(gulp.dest(revealJsDestDir + '/plugin/zoom-js/'));

        return plugins.mergeStreams(
            mainRevealCss,
            paperCSS,
            mainRevealJs,
            zenBurnCss,
            notesJs,
            notesHtml,
            zoomJs,
            markedJs
        );
    });

    ////////////////////////////// Managing highlightJS and dependencies
    // We copy in revealjs, because we cannot set it up on revealjs
    // so.. reusing. cf. https://github.com/hakimel/reveal.js/#dependencies
    /////////////////
    gulp.task('prepare:highlightjs', function () {
        var highlightNodeModule = current_config.nodeModulesDir + '/highlightjs',
            highlightDestDir = current_config.distDir + '/reveal.js/plugin/highlight',
            highlightjsStyleRename = gulp.src(highlightNodeModule + '/styles/*.css')
                .pipe(plugins.rename(function (path) {
                    // Removing the ".min" part of the name to avoid revealjs messing up
                    path.basename += ".min";
                }))
                .pipe(gulp.dest(highlightDestDir + '/styles/')),
            highlightScriptMinified = gulp.src(highlightNodeModule + '/highlight.pack.min.js')
                .pipe(plugins.rename('highlight.js'))
                .pipe(gulp.dest(highlightDestDir));

        return plugins.mergeStreams(highlightjsStyleRename, highlightScriptMinified);

    });

    ////////////////////////////// Managing fontawesome and dependencies
    gulp.task('prepare:fontawesome', function () {

        var fontAwesomeCss = gulp.src(current_config.nodeModulesDir + '/font-awesome/css/**/*')
            .pipe(gulp.dest(current_config.distDir + '/styles/'));

        var fontAwesomeFonts = gulp.src(current_config.nodeModulesDir + '/font-awesome/fonts/**/*')
            .pipe(gulp.dest(current_config.distDir + '/fonts/'));

        return plugins.mergeStreams(fontAwesomeCss, fontAwesomeFonts);
    });
};
