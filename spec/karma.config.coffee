module.exports = (config) ->
    config.set

        # basePath: "./"
        testPattern: "spec/*.mocha.coffee"
        frameworks: [ 
            "mocha"
            "chai"
            "sinon"
        ]

        # list of files / patterns to load in the browser
        files: [
            "*.mocha.coffee"
            "fixtures/**/*.html"
        ]

        reporters: [
            "spec", 
            'growl-notifications'
        ]

        preprocessors:
            '**/*.coffee': ['coffee'],
            'fixtures/**/*.html': ['html2js']

        browserNoActivityTimeout: 5000

        # web server port
        # CLI --port 9876
        port: 9876

        # enable / disable colors in the output (reporters and logs)
        # CLI --colors --no-colors
        colors: true

        # level of logging
        # possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        # CLI --log-level debug
        logLevel: config.LOG_INFO

        # enable / disable watching file and executing tests whenever any file changes
        # CLI --auto-watch --no-auto-watch
        autoWatch: true

        # Start these browsers, currently available (make sure the plugin is installed & added to plugins below):
        # - Chrome
        # - ChromeCanary
        # - Firefox
        # - Opera
        # - Safari (only Mac)
        # - PhantomJS
        # - IE (only Windows)
        # CLI --browsers Chrome,Firefox,Safari
        # 'Safari' spawns multiple instances and then hangs the computer on shut down (https://github.com/karma-runner/karma/issues/878)
        browsers: [
            "Firefox"
            "Chrome"
            "Safari"
        ]

        # If browser does not capture in given timeout [ms], kill it
        # CLI --capture-timeout 5000
        captureTimeout: 5000

        # Auto run tests on start (when browsers are captured) and exit
        # CLI --single-run --no-single-run
        singleRun: false

        # report which specs are slower than 500ms
        # CLI --report-slower-than 500
        reportSlowerThan: 500

        plugins: [
            "karma-mocha"
            "karma-chai"
            "karma-sinon"
            "karma-coffee-preprocessor"
            "karma-spec-reporter"
            "karma-chrome-launcher"
            "karma-firefox-launcher"
            "karma-safari-launcher"
            "karma-html2js-preprocessor"
            "karma-growl-notifications-reporter"
        ]

    return
