# <link rel="stylesheet" href="../css/styles.css" media="screen">

# The following tasks are available:
#
#  * [`install`](#install): Installs the dependencies listed
#    in the `Nemfile` through npm.
#  * [`build`](#build): Builds the lib files, generates the documentation
#    and compiles the stylesheets.
#  * [`docs`](#docs): Generates the documentation with `docco`.
#  * [`sass`](#sass): Generates the stylesheets with `sass`.
#  * [`lint`](#lint): Lint files with `coffeelint`.
#  * [`compile:<file-name>`](#compile): Compiles all the sources files
#    listed in the corresponding `ymlc` file in `config/lib`. The output
#    files are available in the `lib` folder. A minified version
#    of the file is provided through
#    `uglifyjs`.
#  * [`demo:<demo-name>`](#demo): Compiles and runs one of the demos
#    available as `ymlc`
#    files in the `config/demos` directory.
#  * [`test:<test-name>`](#test): Compiles and runs the test for `<test-name>`,
#    `<test-name>` being the name of any `ymlc` file in the `config/test`
#    folder (without dir path nor extensions).

# Global requires
fs      = require 'fs'
{print} = require 'util'
{spawn} = require 'child_process'

# Allow verbose output when running tasks.
option '-v', '--verbose', 'Enable verbose output mode'

## Helpers

#### Queue

# The `Queue` class allow to run an array of commands
# one after the other. A command is simply a function
# that takes a callback function as only argument.
class Queue
  # Constructs the queue with the passed-in commands.
  constructor: (@commands) ->
    @iterator = 0

  # Starts the queue process.
  run: (callback) ->
    # While there's still a command to process.
    if @iterator < @commands.length
      # The command is executed with a callback that'll
      # let the queue continue.
      @commands[ @iterator ] => @run callback
      @iterator += 1
    else callback?()


#### Functions

# Removes the `ymlc` extension from a file name.
cleanExtension = (o, i) -> o.replace /\..+$/, ""

# Eats extra spaces in a string, used for long tasks description.
eat = (s) -> s.replace /\s+/g, " "

# Returns the passed-in string commented.
comment = (s) ->
  "# #{ s.replace /\n/gm, "\n# "}"

# Returns `true` if the passed-in `path` exists.
exist = (path) ->
  try
    fs.lstatSync path
    true
  catch e
    false

# Verify that the `.tmp` folder exists, and creates it otherwise.
ensureTmp = (options) ->
  unless exist ".tmp"
    fs.mkdirSync ".tmp"
    console.log ".tmp directory created" if options.verbose

##### Configurations Loading
#
# Functions related to loading `ymlc` files located in the `config` directory.
# These files contains `CoffeeScript` code that  be compiled into object.
#
# A `ymlc` file content look like:
#
#     source: [ "file1", "file2", "file3" ]
#     test: "test-file"

# Loads a `ymlc` file and returns the configuration object it contains
# through the `callback` function.
loadConfig = (file, noEval, callback) ->
  # The function can be called with the callback as the second argument.
  # In that case, the `noEval` argument is `false`.
  [callback, noEval] = [noEval, callback] if noEval instanceof Function
  # The file is compiled through `coffee`.
  coffee = spawn 'coffee', ['-p','-c','-b',file]
  coffee.stderr.on 'data', (data) -> print data
  coffee.stdout.on 'data', (data) ->
    # When `noEval` is true, the config content isn't evaluated and
    # returned as a string.
    try
      callback? (if noEval then data.toString() else eval data.toString())
    catch e
      console.log file, noEval, callback
      console.error e

# Generates a command function for the passed-in configuration file.
# The `configs` object is the target object which will stores
# the configuration objects.
loadConfigCommand = (file, noEval, configs) -> (callback) ->
  loadConfig file, noEval, (config) ->
    # The config is stored with the file path without the extension.
    configs[cleanExtension file] = config
    callback?()

# Loads all the configuration files in the specified `dir`.
loadConfigs = (dir, noEval, callback) ->
  configs = {}
  sources = fs.readdirSync dir
  commands = (loadConfigCommand("#{dir}/#{f}",noEval,configs) for f in sources)
  queue = new Queue commands
  queue.run -> callback? configs

##### Templates Loading
#
# Functions related to loading `hamlc` files located in the `templates`
# directory.

# Loads a single `hamlc` file and compiles it with `haml-coffee`.
# The generated template function is passed as argument to the `callback`
# function.
loadTemplate = (file, callback) ->
  fs.readFile file, (err, data) ->
    hamlc = require 'haml-coffee'
    callback? hamlc.compile data.toString()

# Generates a command function for the passed-in template file.
# The compiled template function is then stored in the `templates`
# hash with the path to the template as key.
loadTemplateCommand = (file, templates) -> (callback) ->
  loadTemplate file, (template) ->
    templates[cleanExtension file] = template
    callback?()

# Loads all the template files in the specified `dir`.
loadTemplates = (dir, callback) ->
  templates = {}
  sources = fs.readdirSync dir
  commands = (loadTemplateCommand("#{dir}/#{f}",templates) for f in sources)
  queue = new Queue commands
  queue.run -> callback templates

# Compiles a haml coffee `template` with the specified `context`
# and write the result in an `output` file.
writeTemplate = (template, output, context, callback) ->
  loadTemplate template, (tmpl)->
    fs.writeFile output, tmpl(context), callback

##### Command Line Functions

# Runs a command line program.
#
#     run "coffee", [ '-e', 'console.log "Hello World!"' ], ->
#       console.log "command exited"
run = (command, options, callback) ->
  exe = spawn command, options
  exe.stdout.on 'data', (data) -> print data.toString()
  exe.stderr.on 'data', (data) -> print data.toString()
  exe.on 'exit', (status) -> callback?()

# Run a command line program available in the `node_modules` directory.
bundleRun = (command, options, callback) ->
  run "./node_modules/.bin/#{command}", options, callback

##### Coffee Compilation

# Joins a bunch of source files to an `output` file.
join = (sources, output, callback) ->
  # The file extension is added to all source files.
  files = ("#{file}.coffee" for file in sources)

  # Compiles the main javascript output file.
  run 'coffee', ['--join', output, '--compile'].concat(files), ->
    # Once done, a minified version is produced using `uglifyjs`.
    minified = output.replace(".js",".min.js")
    bundleRun 'uglifyjs', ["-nm","-o", minified, output], callback

##### Test Task Generator

# Files to be included for each tests.
TEST_DEPENDENCIES = ["test/test-helpers"]

# Defines a test tast for the `unit` configuration file.
testTask = (unit) ->
  task "test:#{unit}", "Compiles and runs tests for #{unit}", (opts) ->
    # Generated files are placed in the `.tmp` folder.
    ensureTmp opts

    # Prepares the tests runner generation.
    hamlc = "templates/test/test.hamlc"
    html = ".tmp/test-#{unit}.html"
    context =
      title: unit
      test: unit

    # Generates the test runner.
    writeTemplate hamlc, html, context, ->
      # Load the specified test configuration.
      loadConfig "config/test/#{unit}.ymlc", (config) ->
        console.log "Compilation configuration: ", config if opts.verbose

        # Prepares the test compilation.
        lib = ".tmp/#{unit}.js"
        test = ".tmp/test-#{unit}.js"

        # Compiles the code to be tested.
        join [].concat(config.source), lib, ->
          console.log "#{unit} sources compiled"

          # Compiles the tests.
          join TEST_DEPENDENCIES.concat(config.test), test, ->
            console.log "#{unit} tests compiled"

            # Launch the test runner.
            run 'gnome-open', [".tmp/test-#{unit}.html"]

##### Compilation Task Generator

# Stores all the lib files compilation tasks for the `cake build` task.
LIB_COMPILATION_TASKS = []

# Defines a compilation task that takes all the source files defined
# in the specified configuration file and generates a javascript file
# with the name of the configuration file.
libTask = (unit) ->
  LIB_COMPILATION_TASKS.push "compile:#{unit}"
  task "compile:#{unit}", "Compiles the #{unit}.js file", (opts) ->
    # Loads the configuration file.
    loadConfig "config/lib/#{unit}.ymlc", (config) ->
      console.log "Compilation configuration: ", config if opts.verbose
      # Compiles the file.
      join [].concat(config.source), "lib/#{unit}.js", ->
        console.log "#{unit}.js compiled"

##### Demo Task Generator

# Defines a task that compiles a demo file and open it in a browser.
demoTask = (unit) ->
  task "demo:#{unit}", eat("Creates a demo file in the .tmp directory and then
                            run it in a browser"), (opts) ->
    # Generated files are placed in the `.tmp` folder.
    ensureTmp opts

    # Loads the configuration file.
    loadConfig "config/demos/#{unit}.ymlc", (config) ->
      console.log "Compilation configuration: ", config if opts.verbose

      sources = ("#{file}.coffee" for file in config.source)

      # Prepares the demo compilation.
      output="#{unit}.js"
      options = ['--join',".tmp/#{output}",'--compile'].concat sources

      # Compiles the demo files.
      run 'coffee', options, ->
        console.log "#{unit} sources compiled" if opts.verbose

        # Prepares the demo html file generation.
        hamlc = "templates/#{ config.template }.hamlc"
        html = ".tmp/#{unit}.html"
        context = demo: output

        # Generates the demo html file.
        writeTemplate hamlc, html, context, ->
          console.log "#{html} generated" if opts.verbose

          # Opens the file.
          run 'gnome-open', [".tmp/#{unit}.html"]

## Tasks

# <a name="install"></a>
#### cake install

# Installs all the dependencies listed in the `Nemfile`.
task 'install', 'Installs the dependencies defined in Nemfile', (options) ->

  # The content of the `Nemfile` file is inserted in a placeholder in
  # the `config/nem.coffee` that contains the `npm` function declaration.
  nem = fs.readFileSync 'src/nem.coffee'
  nemfile = fs.readFileSync 'Nemfile'
  source = nem.toString().replace "###NPM_DECLARATION###", nemfile.toString()

  # The produced source code is then executed by `coffee`.
  run 'coffee', [ '-e', source ]

# <a name="build"></a>
#### cake build

task 'build', 'Invoke cake docs, sass and compile', ->
  invoke 'docs'
  invoke 'sass'
  invoke 'compile'

# <a name="docs"></a>
#### cake docs

# The following expression math rails like require
# in documentation and extract the token to require.
#
# In fact, the token is the base name of a configuration
# file in `config/docs/demos` that will be used to generate
# a live demo within the documentation.
REQUIRE_RE = ///^
  \s*           # indentation
  \#=\s*require # rails convention for require
  \s+
  ([^\s]+)      # the configuration name
///gm

# Defines a task that generates the documentation.
task 'docs', 'Generate annotated source code with Docco', (options) ->
  ensureTmp options
  taskConfig = "config/docs/docs.ymlc"
  demosConfig = "config/docs/demos"
  demosTemplates = "templates/docs"

  # Load the configuration file.
  loadConfig taskConfig, (config) ->
    loadConfigs demosConfig, true, (configs) ->
      loadTemplates demosTemplates, (templates) ->

        headerTmpl = templates["templates/#{config.headerTemplate}"]
        if headerTmpl?
          header = comment headerTmpl()
        else
          header = ""
          console.log "Couldn't find header templates/#{config.headerTemplate}"

        # The `prepareForDocco` function takes a source file, prepend a header
        # provided by the `config.headerTemplate` option and replace demo
        # requires by the corresponding results, the generated file is then
        # placed in the `.tmp` folder.
        prepareForDocco = (file, callback) ->
          copy = ".tmp/#{ file.split("/").pop() }.coffee"
          file = if exist file then file else "#{file}.coffee"

          fs.readFile file, 'utf-8', (err, data) ->
            return console.error err, file, copy if err
            source = data.toString()
            tpl = templates["templates/#{config.builderTemplate}"]

            if tpl?
              source = source.replace REQUIRE_RE, (match,req) ->
                conf = configs["#{demosConfig}/#{req}"]

                if conf?
                  o = eval conf
                  o.config = conf
                  return comment tpl o
                else
                  console.log "Couldn't find config #{demosConfig}/#{req}"
                  return ""

            else console.log "Couldn't find template #{config.builderTemplate}"

            console.log "copy #{ file } to #{ copy }" if options.verbose
            fs.writeFile copy, "#{header}\n#{source}", callback copy

        # Prepares the documentation generation.
        sources = config.source
        files = []

        # The `prepare` function is a recursive function that will
        # process the files defines in the `sources` array and returns
        # an array containing the path of the generated file as callback
        # argument.
        prepare = (callback) ->
          # As long as there's files in the array.
          if sources.length
            file = sources.pop()
            prepareForDocco file, (copy) ->
              # And the generated file is stored in the corresponding array.
              files.push copy
              # Continues to the next file.
              prepare callback
          # Returns the files array in the callback.
          else callback files

        # Run the iterations.
        prepare (files) ->
          # Generates the documentation for all the files processed before.
          bundleRun 'docco', files, ->
            # Removes all the temporary files.
            run 'rm', [file] for file in files
            console.log "generated files cleaned" if options.verbose

# <a name="sass"></a>
#### cake sass

# Defines a task that compile the sass stylesheets.
task 'sass', 'Compiles the widgets stylesheet', (options) ->
  loadConfig "config/sass.ymlc", (config) ->
    for file in config.source
      run 'sass', ["#{file}.sass:#{file}.css","--style","compressed"]

# <a name="lint"></a>
#### cake lint

# Generates a command function that lint the specified `file`.
lint = (file) -> (callback) ->
  console.log "> Do '#{file}' has lints ?"
  bundleRun 'coffeelint', ["-f", "config/lint.json", file], callback

# Runs all files defined in `config/lint.ymlc` through `coffeelint`.
task 'lint', 'Lint the widgets sources files', (options) ->
  loadConfig "config/lint.ymlc", (config) ->
    files = []
    for file in config.source
      files.push if exist file then file else "#{file}.coffee"

    # Creates the `Queue` and process it.
    queue = new Queue (lint file for file in files)
    queue.run()

# <a name="compile"></a>
#### cake compile

task 'compile', 'Compiles all the javascript files from configs', (options) ->
  invoke libTask for libTask in LIB_COMPILATION_TASKS

#### cake compile: config

# Each `ymlc` file in the `config/lib` folder will be available
# as a compilation task.
libTask file for file in fs.readdirSync('config/lib').map cleanExtension

# <a name="demo"></a>
#### cake demo: config

# Each `ymlc` file in the `config/demos` folder will be available
# as a demo task.
demoTask file for file in fs.readdirSync('config/demos').map cleanExtension

# <a name="test"></a>
#### cake test: config

# Each `ymlc` file in the `config/test` folder will be available
# as a test task.
testTask file for file in fs.readdirSync('config/test').map cleanExtension

