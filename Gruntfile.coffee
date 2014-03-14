{spawn} = require 'child_process'
{print} = require 'util'
Q = require 'q'

run = (command) ->
  defer = Q.defer()
  [command, args...] = command.split(/\s+/g)
  exe = spawn command, args
  exe.stdout.on 'data', (data) -> print data
  exe.stderr.on 'data', (data) -> print data
  exe.on 'exit', (status) ->
    if status is 0 then defer.resolve(status) else defer.reject(status)
  defer.promise

module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      dev:
        options:
          join: true
          sourceMap: true

        files:
          'lib/widgets.js': [
            'src/index.litcoffee'
            'src/mixins/*.litcoffee'
            'src/gestures/*.litcoffee'
            'src/feedbacks/*.litcoffee'
            'src/processors/*.litcoffee'
            'src/interactions/*.litcoffee'
          ]

    uglify:
      prod:
        options:
          sourceMap: 'lib/widgets.min.js.map'
        files:
          'lib/widgets.min.js': ['lib/widgets.js']

    watch:
      scripts:
        files: [
          'src/**/*.litcoffee'
          'specs/**/*.coffee'
          'css/**/*.styl'
          'templates/**/*.jade'
        ]
        tasks: [
          'coffee'
          'jade'
          'stylus'
          'uglify'
          'docco'
        ]

    growl:
      spectacular_success:
        title: 'Spectacular Tests'
        message: 'All test passed'

      spectacular_failure:
        title: 'Spectacular Tests'
        message: 'Some tests failed'

    docco:
      dev:
        src: ['src/**/*.litcoffee']
        options:
          output: 'docs/'

    jade:
      dev:
        options:
          pretty: true
          compiledDebug: true

        files:
          'demos/index.html': 'templates/index.jade'

    stylus:
      dev:
        options:
          debug: true
          linenos: true
          compress: false
          paths: [
            'css/partials'
          ]
        files:
          'css/widgets.css': 'css/widgets.styl'

  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-growl')
  grunt.loadNpmTasks('grunt-docco')

  grunt.registerTask('default', ['coffee', 'uglify'])
