# <link rel="stylesheet" href="../css/styles.css" media="screen">

fs      = require 'fs'
{print} = require 'util'
{spawn} = require 'child_process'

# Allow verbose output when running tasks.
option '-v', '--verbose', 'Enable verbose output mode'

cleanYml=(o,i)-> o.replace ".yml", ""

# Files in the `test` folder to be included for each tests.
TestDependencies = [ "test/test-helpers" ]
# Each `yml` file in the `config/units` folder is granted
# as a test unit compilation configuration.
TestUnits = fs.readdirSync('config/units').map cleanYml
# Each `yml` file in the `config/demos` folder is granted
# as a demo compilation configuration.
Demos = fs.readdirSync('config/demos').map cleanYml
# Each `yml` file in the `config/lib` folder is granted
# as a lib compilation configuration.
LibFiles = fs.readdirSync('config/lib').map cleanYml

## Helpers

#### Queue

# The `Queue` class allow to run an array of commands
# one after the other. A command is simply function
# that takes a callback function as only argument.
class Queue
  # Constructs the queue with the passed-in commands.
  constructor:(@commands)->
    @iterator = 0

  # Starts the queue process.
  run:->
    # While there's still a command to process.
    if @iterator < @commands.length
      # The command is executed with a callback that'll let the queue continue.
      @commands[ @iterator ] => @run()
      @iterator += 1

#### Functions

# Eats extra spaces in a string, used for tasks description.
eat=(s)-> s.replace /\s+/g, " "

# Returns `true` if the passed-in `path` exists.
exist=(path)->
  try
    fs.lstatSync path
    true
  catch e
    false

# Load a `yml` file and returns the configuration object it contains
# through the `callback` function.
loadConfig=(file, callback)->
  coffee = spawn 'coffee', ['-p','-c','-b',file]
  coffee.stdout.on 'data',( data )->
    o = eval data.toString()
    callback? o

# Runs a command line program.
#
#     run "coffee", [ '-e', 'console.log "Hello World!"' ], ->
#       console.log "command exited"
run=(command, options, callback)->
  exe = spawn command, options
  exe.stdout.on 'data', ( data )-> print data.toString()
  exe.stderr.on 'data', ( data )-> print data.toString()
  exe.on 'exit', ( status )-> callback?()

# Run a command line program available in the `node_modules` directory.
bundleRun=(command, options, callback)->
  run "./node_modules/.bin/#{command}", options, callback

# Joins a bunch of source files to an `output` file.
join=(sources, output, callback)->
  # The file extension is added to all source files.
  files = ( "#{file}.coffee" for file in sources )

  # Compiles the main javascript output file.
  run 'coffee', ['--join', output, '--compile' ].concat(files), ->
    # Once done, a minified version is produced using `uglifyjs`.
    minified = output.replace(".js",".min.js")
    bundleRun 'uglifyjs', ["-nm","-o", minified, output ], callback

# Compiles a haml coffee `template` with the specified `context`
# and write the result in an `output` file.
hamlcompile=(template, output, context, callback)->
  fs.readFile template, (err,data)->
    hamlc = require 'haml-coffee'
    tmpl = hamlc.compile data.toString()
    fs.writeFile output, tmpl(context), callback

# Verify that the `.tmp` folder exists, and creates it otherwise.
ensureTmp=(options)->
  unless exist ".tmp"
    fs.mkdirSync ".tmp"
    console.log ".tmp directory created" if options.verbose

# Defines a test tast for the `unit` configuration file.
testTask=(unit)->
  task "test:#{unit}", "Compiles and runs tests for the #{unit} unit", (opts)->
    #
    ensureTmp opts
    hamlcompile "templates/test.hamlc",".tmp/test-tmp.html",{ title:unit }, ->
      loadConfig "config/units/#{unit}.yml", (config)->
        if opts.verbose
          console.log "Compilation configuration: "
          console.log config

        lib = ".tmp/widgets.js"
        test = ".tmp/test-widgets.js"

        join [].concat(config.source), lib, ->
          console.log "#{unit} sources compiled" if opts.verbose

          join TestDependencies.concat( config.test ), test, ->
            console.log "#{unit} tests compiled" if opts.verbose

            run 'gnome-open', [ ".tmp/test-tmp.html" ]

libTask=(unit)->
  task "compile:#{unit}", "Compiles the #{unit}.js file", (opts)->
    loadConfig "config/lib/#{unit}.yml", (config)->
      if opts.verbose
        console.log "Compilation configuration: "
        console.log config
      join [].concat(config.source), "lib/#{unit}.js", ->
        console.log "#{unit} sources compiled" if opts.verbose

# Defines a task that compiles a demo file and open it in a browser.
demoTask=(unit)->
  task "demo:#{unit}", eat("Creates a demo file in the .tmp directory and then
                            run it in a browser"), (opts)->
    ensureTmp opts

    loadConfig "config/demos/#{unit}.yml", (config)->
      if opts.verbose
        console.log "Compilation configuration: "
        console.log config
      output="#{unit}.js"
      options = ['--join',".tmp/#{output}",'--compile' ].concat config.source

      run 'coffee', options, ->
        console.log "#{unit} sources compiled" if opts.verbose
        hamlc = "templates/#{ config.template }.hamlc"
        html = ".tmp/#{unit}.html"
        context = demo:output
        hamlcompile hamlc, html, context, ->
          console.log "#{html} generated" if opts.verbose
          run 'gnome-open', [ ".tmp/#{unit}.html" ]

lint=(file, callback)->
  console.log "> Do '#{file}' has lints ?"
  bundleRun 'coffeelint', [ "-f", "lint.json", file ], callback

lintCommand=(file)-> (callback)-> lint file, callback

doccoCopy=(file,callback)->
  copy = ".tmp/#{ file.split("/").pop() }.coffee"
  run 'cp', [ file, copy ], callback copy

## Tasks Definition

# Installs
task 'install', 'Installs the dependencies defined in the Nemfile', (options)->
  nem = fs.readFileSync 'config/nem.coffee'
  nemfile = fs.readFileSync 'Nemfile'

  run 'coffee', [ '-e', "#{ nem }\n#{ nemfile }" ]

# Defines a task that generates the documentation.
task 'docs', 'Generate annotated source code with Docco', (options)->
  ensureTmp options

  loadConfig "config/docs.yml", (config)->
    sources = config.source
    files=[]
    generated=[]
    next=(callback)->
      if sources.length
        file = sources.pop()
        if exist file
          doccoCopy file, (copy)->
            if options.verbose
              console.log "tmp copy #{copy} created for #{file}"
            generated.push copy
            files.push copy
            next callback
        else
          files.push "#{file}.coffee"
          next callback
      else
        callback files

    next (files)->
      bundleRun 'docco', files, ->
        run 'rm', [file] for file in generated
        console.log "generated files cleaned" if options.verbose

# Defines a task that compile the sass stylesheets.
task 'sass', 'Compiles the widgets stylesheet', ->
  run 'sass', [
    "css/widgets.sass:css/widgets.css",
    "--style","compressed" ]

  run 'sass', [
    "css/styles.sass:css/styles.css",
    "--style","compressed" ]

# Runs all files through coffeelint.
task 'lint', 'Lint the widgets sources files', ->
  loadConfig "config/lint.yml", (config)->
    files = []
    for file in config.source
      files.push if exist file then file else "#{file}.coffee"

    batch = new Queue ( lintCommand file for file in files )
    batch.run()

# Generates one task per compilation unit.
libTask file for file in LibFiles

# Generates one task per compilation unit.
demoTask file for file in Demos

# Generates one task per compilation unit.
testTask file for file in TestUnits

