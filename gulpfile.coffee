gulp = require 'gulp'
# gulp plugins - this auto-loads anything with gulp- and puts it in global scope under the "plugins" namespace
plugins = require('gulp-load-plugins')()


### Configuration ###
config = require './gulpconfig/gulpconfig.json'

### convenience methods (our utils) ###
gulp.markAsFailed = (err) ->
  console.log "gulp encountered an error: ", err
  process.exit 1

isProd = ->
  return require('yargs').argv.production



### Aliases (or batch tasks) ###
# TIP: if you need to run in order: https://github.com/gulpjs/gulp/blob/master/docs/recipes/running-tasks-in-series.md
gulp.task 'default', ['lint', 'less', 'uglify']


### Task Definition ####

gulp.task "clean", ->

  gulp.src( [ config.js.dest, config.less.dest ],  read: false )
    .pipe plugins.clean()


gulp.task "lint", ->
  
  reporter = config.jshint.reporter

  gulp.src config.js.src 
    .pipe plugins.jshint() 
    .pipe plugins.jshint.reporter reporter
    .on( 'error', onWarning )


# TODO: better error handling: https://www.npmjs.org/package/gulp-plumber OR
# https://github.com/gulpjs/gulp/blob/master/docs/recipes/combining-streams-to-handle-errors.md
gulp.task "less", ->

  lessOptions =
    # "paths": "./node_modules/bootstrap/less/" # yeah, I cheated here ;)
    "compress": true
    "sourceMap": true
    "clean-css": true
  
  gulp.src config.less.src
    .pipe plugins.plumber()
    # .pipe plugins.sourcemaps.init()
    # providing a relative path to gulp.dest allows us to externalize the sourceMap 
    # (so our users don't pay for it, metaphorically and literally in terms of Bandwidth)
    # .pipe plugins.sourcemaps.write( config.less.dest ) 
  	.pipe plugins.less( lessOptions )
  	.pipe gulp.dest config.less.dest 
    .on 'error', onError


gulp.task 'uglify', ->
  gulp.src( config.js.src )
    # streams!
    .pipe plugins.concat( config.js.bundleFile )
    .pipe plugins.uglify() 
    .pipe gulp.dest( config.js.dest ) 

gulp.task 'test', ->
  # Putting 'dummy' here forces gulp to use test files defined in ./test/client/karma.conf.js
  gulp.src(["dummy"])
    .pipe( plugins.karma(
      configFile: config.karma.configFile
      action:'watch'
    )).on "error", (err) ->
      throw err
      return  

# we can specify an array of dependent tasks as the second parameter, 
# as we do with ['less', 'uglify'] in this case, 
# in order to run tasks sequentially / prior to our target task
# this will run both tasks prior to kicking off the watch.
gulp.task 'watch', ['less', 'uglify'], ->
  
  gulp.watch config.js.src, ['lint', 'uglify']
  gulp.watch config.less.src, ['less']









# Command line option:
#  --fatal=[warning|error|off]

# Return true if the given level is equal to or more severe than
# the configured fatality error level.
# If the fatalLevel is 'off', then this will always return false.
# Defaults the fatalLevel to 'error'.
isFatal = (level) ->
  ERROR_LEVELS.indexOf(level) <= ERROR_LEVELS.indexOf(fatalLevel or "error")

# Handle an error based on its severity level.
# Log all levels, and exit the process for fatal levels.
handleError = (level, error) ->
  console.log error
  process.exit 1  if isFatal(level)
  return

# Convenience handler for error-level errors.
onError = (error) ->
  handleError.call this, "error", error
  return

# Convenience handler for warning-level errors.
onWarning = (error) ->
  handleError.call this, "warning", error
  return

fatalLevel = require("yargs").argv.fatal

ERROR_LEVELS = [
  "error"
  "warning"
]
