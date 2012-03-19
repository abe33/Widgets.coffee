# <link rel="stylesheet" href="../css/styles.css" media="screen">

# The following tasks are available:
#
#  * `install`: Installs the dependencies listed in the `Nemfile` through npm.
#  * `docs`: Generates the documentation with `docco`.
#  * `sass`: Generates the stylesheets with `sass`.
#  * `lint`: Lint files with `coffeelint`.
#  * `compile:<file-name>`: Compiles all the sources files listed in the
#    corresponding `yml` file in `config/lib`. The output files are available
#    in the `lib` folder. A minified version of the file is provided through
#    `uglifyjs`.
#  * `demo:<demo-name>`: Compiles and runs one of the demos available as `yml`
#    files in the `config/demos` directory.
#  * `test:<test-name>`: Compiles and runs the test for `<test-name>`,
#    `<test-name>` being the name of any `yml` file in the `config/units`
#    folder (without dir path nor extensions).

# Global requires
fs      = require 'fs'
{print} = require 'util'
{spawn} = require 'child_process'

# Allow verbose output when running tasks.
option '-v', '--verbose', 'Enable verbose output mode'

## Helper Functions

# Removes the `yml` extension from a file name.
cleanYml=(o,i)-> o.replace ".yml", ""

# Eats extra spaces in a string, used for long tasks description.
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

#### Test Task Generator

# Files to be included for each tests.
TestDependencies = [ "test/test-helpers" ]

# Defines a test tast for the `unit` configuration file.
testTask=(unit)->
  task "test:#{unit}", "Compiles and runs tests for the #{unit} unit", (opts)->
    # Generated files are placed in the `.tmp` folder.
    ensureTmp opts

    # Prepares the tests runner generation.
    hamlc = "templates/test.hamlc"
    html = ".tmp/test-#{unit}.html"
    context =
      title:unit
      test:unit

    # Generates the test runner.
    hamlcompile hamlc, html, context, ->
      # Load the specified test configuration.
      loadConfig "config/units/#{unit}.yml", (config)->
        console.log "Compilation configuration: ", config if opts.verbose

        # Prepares the test compilation.
        lib = ".tmp/#{unit}.js"
        test = ".tmp/test-#{unit}.js"

        # Compiles the code to be tested.
        join [].concat(config.source), lib, ->
          console.log "#{unit} sources compiled" if opts.verbose

          # Compiles the tests.
          join TestDependencies.concat( config.test ), test, ->
            console.log "#{unit} tests compiled" if opts.verbose

            # Launch the test runner.
            run 'gnome-open', [ ".tmp/test-#{unit}.html" ]

#### Compilation Task Generator

# Defines a compilation task that takes all the source files defined
# in the specified configuration file and generates a javascript file
# with the name of the configuration file.
libTask=(unit)->
  task "compile:#{unit}", "Compiles the #{unit}.js file", (opts)->
    # Loads the configuration file.
    loadConfig "config/lib/#{unit}.yml", (config)->
      console.log "Compilation configuration: ", config if opts.verbose
      # Compiles the file.
      join [].concat(config.source), "lib/#{unit}.js", ->
        console.log "#{unit} sources compiled" if opts.verbose

#### Demo Task Generator

# Defines a task that compiles a demo file and open it in a browser.
demoTask=(unit)->
  task "demo:#{unit}", eat("Creates a demo file in the .tmp directory and then
                            run it in a browser"), (opts)->
    # Generated files are placed in the `.tmp` folder.
    ensureTmp opts

    # Loads the configuration file.
    loadConfig "config/demos/#{unit}.yml", (config)->
      console.log "Compilation configuration: ", config if opts.verbose

      # Prepares the demo compilation.
      output="#{unit}.js"
      options = ['--join',".tmp/#{output}",'--compile' ].concat config.source

      # Compiles the demo files.
      run 'coffee', options, ->
        console.log "#{unit} sources compiled" if opts.verbose

        # Prepares the demo html file generation.
        hamlc = "templates/#{ config.template }.hamlc"
        html = ".tmp/#{unit}.html"
        context = demo:output

        # Generates the demo html file.
        hamlcompile hamlc, html, context, ->
          console.log "#{html} generated" if opts.verbose

          # Opens the file.
          run 'gnome-open', [ ".tmp/#{unit}.html" ]

## Tasks Definitions

#### cake install

# Installs all the dependencies listed in the `Nemfile`.
task 'install', 'Installs the dependencies defined in the Nemfile', (options)->

  # The content of the `Nemfile` file is inserted in a placeholder in
  # the `config/nem.coffee` that contains the `npm` function declaration.
  nem = fs.readFileSync 'config/nem.coffee'
  nemfile = fs.readFileSync 'Nemfile'
  source = nem.toString().replace "#<<NPM_DECLARATION>>", nemfile.toString()

  # The produced source code is then executed by `coffee`.
  run 'coffee', [ '-e', source ]

#### cake docs

# Creates a copy of the passed in `file` with a `.coffee` extension
# to allow `docco` to generates documentation for that file. The path
# to the generated file is passed to the callback function.
doccoCopy=(file,callback)->
  copy = ".tmp/#{ file.split("/").pop() }.coffee"
  run 'cp', [ file, copy ], callback copy

# Defines a task that generates the documentation.
task 'docs', 'Generate annotated source code with Docco', (options)->
  # Some files that don't have the `coffee` extension will be cloned
  # and placed in the `.tmp` folder with the `coffee` extension.
  ensureTmp options

  # Load the configuration file.
  loadConfig "config/docs.yml", (config)->

    # Prepares the documentation generation.
    sources = config.source
    files=[]
    # Files that don't have the `coffee` extensions will be cloned and
    # will be stored in the `.tmp` dir, and removed at the end of the task.
    generated=[]

    # Iterates over a file and verify that it have the `coffee` extension.
    # If not, the file is cloned, renamed and moved to the `.tmp` folder.
    next=(callback)->
      # As long as there's files in the array.
      if sources.length
        file = sources.pop()
        # If the file don't have any extension, `exist` will return `true`.
        if exist file
          # Then a copy of the file is placed in `.tmp`.
          doccoCopy file, (copy)->
            if options.verbose
              console.log "tmp copy #{copy} created for #{file}"
            # And the generated file is stored in the corresponding array.
            generated.push copy
            files.push copy
            # Continues to the next file.
            next callback
        else
          # Stores the file woth the coffee extension.
          files.push "#{file}.coffee"
          next callback
      # Returns the files array in the callback.
      else callback files

    # Run the iterations.
    next (files)->
      # Generates the documentation for all the files
      # in the configuration file.
      bundleRun 'docco', files, ->
        # Removes all the temporary files.
        run 'rm', [file] for file in generated
        console.log "generated files cleaned" if options.verbose

#### cake sass

# Defines a task that compile the sass stylesheets.
task 'sass', 'Compiles the widgets stylesheet', ->
  loadConfig "config/sass.yml", (config)->
    for file in config.source
      run 'sass', ["#{file}.sass:#{file}.css","--style","compressed" ]

#### cake lint

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
      # The command is executed with a callback that'll
      # let the queue continue.
      @commands[ @iterator ] => @run()
      @iterator += 1

# Generates a command function that lint the specified `file`.
lint=(file)-> (callback)->
  console.log "> Do '#{file}' has lints ?"
  bundleRun 'coffeelint', [ "-f", "config/lint.json", file ], callback

# Runs all files defined in `config/lint.yml` through `coffeelint`.
task 'lint', 'Lint the widgets sources files', ->
  loadConfig "config/lint.yml", (config)->
    files = []
    for file in config.source
      files.push if exist file then file else "#{file}.coffee"

    # Creates the `Queue` and process it.
    queue = new Queue ( lint file for file in files )
    queue.run()

#### cake compile:config

# Each `yml` file in the `config/lib` folder will be available
# as a compilation task.
libTask file for file in fs.readdirSync('config/lib').map cleanYml

#### cake demo:config

# Each `yml` file in the `config/demos` folder will be available
# as a demo task.
demoTask file for file in fs.readdirSync('config/demos').map cleanYml

#### cake test:config

# Each `yml` file in the `config/units` folder will be available
# as a test task.
testTask file for file in fs.readdirSync('config/units').map cleanYml

