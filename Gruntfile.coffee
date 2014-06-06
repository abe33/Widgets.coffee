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
            'src/index.coffee'
            'src/hash.coffee'
          ]
          # 'lib/widgets.utils.js': [
          #   'src/utilities/*.coffee'
          # ]
          'lib/widgets.common.js': [
            'src/widgets/*.coffee'
          ]
          'lib/widgets.mixins.js': [
            'src/mixins/*.coffee'
          ]

    uglify:
      prod:
        options:
          sourceMap: true
        files:
          'lib/widgets.min.js': ['lib/widgets.js']
          # 'lib/widgets.utils.min.js': ['lib/widgets.utils.js']
          'lib/widgets.common.min.js': ['lib/widgets.common.js']
          'lib/widgets.mixins.min.js': ['lib/widgets.mixins.js']

    watch:
      scripts:
        files: [
          'src/**/*.coffee'
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
        src: ['lib/*.coffee']
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
