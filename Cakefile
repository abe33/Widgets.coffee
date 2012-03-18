# <link rel="stylesheet" href="../css/styles.css" media="screen">

fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'

# Allow verbose print
option '-v', '--verbose', 'Enable verbose output mode'

TestDependencies = [ "test-helpers" ]
Units = fs.readdirSync('config/units').map (o,i)-> o.replace ".yml", ""
Sources = fs.readFileSync('config/sources', 'utf-8').split /\s+/g
Sources.pop() if Sources[ Sources.length-1 ] is ''

## Helpers

#### Batch
class Batch
  constructor:( @commands )->
    @iterator = -1

  run:->
    if @iterator + 1 < @commands.length
      @commands[ @iterator + 1 ] =>
        @run()
      @iterator += 1

#### Functions

eat=(s)-> s.replace /\s+/g, " "

exist=(path)->
  try
    fs.lstatSync path
    return true
  catch e
    return false

loadConfig=(file,callback)->
  coffee = spawn 'coffee', ['-p','-c','-b',file]
  coffee.stdout.on 'data',( data )->
    o = eval data.toString()
    callback? o

run=(command, options, callback)->
  exe = spawn command, options
  exe.stdout.on 'data', ( data )-> print data.toString()
  exe.stderr.on 'data', ( data )-> print data.toString()
  exe.on 'exit', ( status )-> callback?()

bundleRun=(command, options, callback)->
  run "./node_modules/.bin/#{command}", options, callback

join=(dir, contents, inFile, callback)->
  files = ( "#{dir}/#{file}.coffee" for file in contents )

  options = ['--join', inFile, '--compile' ].concat files

  run 'coffee', options, ->
    bundleRun 'uglifyjs', [
      "-nm",
      "-o", inFile.replace(".js",".min.js"),
      inFile,
    ], callback

hamlcompile=(template, output, context, callback)->
  fs.mkdirSync ".tmp" unless exist ".tmp"

  fs.readFile template, (err,data)->
    hamlc = require 'haml-coffee'
    tmpl = hamlc.compile data.toString()
    fs.writeFile output, tmpl(context), callback

testTask=(file)->
  task "test:#{file}", "Compiles and runs tests for the #{file} file", (opts)->
    hamlcompile "templates/test.hamlc",".tmp/test-tmp.html",{ title:file }, ->
      loadConfig "config/units/#{file}.yml", (config)->
        src = ".tmp/widgets.js"
        test = ".tmp/test-widgets.js"

        join "src", config.depends.concat( file ), src, ->
          console.log "#{file} sources compiled" if opts.verbose

          join "test",
               TestDependencies.concat( config.test ),
               test, ->
                 console.log "#{file} tests compiled" if opts.verbose

                 run 'gnome-open', [ ".tmp/test-tmp.html" ]

lint=(file, callback)->
  console.log "> Do '#{file}' has lints ?"
  bundleRun 'coffeelint', [ "-f", "lint.json", file ], callback

lintCommand=(file)-> (callback)-> lint file, callback

## Tasks Definition

task 'install', 'Installs the dependencies defined in the Nemfile', (options)->
  nem = fs.readFileSync 'config/nem.coffee'
  nemfile = fs.readFileSync 'Nemfile'

  run 'coffee', [ '-e', "#{ nem }\n#{ nemfile }" ]

# Generates one task per tests unit.
testTask file for file in Units

# Defines a task that runs the whole test suite.
task 'test', 'Compiles and runs all the tests', (options)->
  hamlcompile "templates/test.hamlc",".tmp/test-tmp.html",{ title:"All" }, ->
    file = ".tmp/widgets.js"
    join "src", Sources, file, ->
      console.log "all sources generated" if options.verbose
      allTests = ( "test-#{file}" for file in Units )
      file = ".tmp/test-widgets.js"
      join "test", TestDependencies.concat( allTests ), file, ->
        console.log "all tests generated" if options.verbose

        run 'gnome-open', [ ".tmp/test-tmp.html" ]

# Defines a task that generates the documentation and compiles
# the output javascript files.
task 'build', eat("Compiles the javascript sources
                   and generates the documentation"), ->
  invoke "compile"
  invoke "docs"

# Defines a task that compiles the output javascript files.
task 'compile', 'Compiles the javascript sources', (options)->
  file = "lib/widgets.js"
  join "src", Sources, file, ->
    console.log "#{file} generated" if options.verbose

# Defines a task that generates the documentation.
task 'docs', 'Generate annotated source code with Docco', ->
  run 'cp', [ 'Cakefile', '.tmp/Cakefile.coffee' ], ->
    files = ( "src/#{file}.coffee" for file in Sources )
    files.push ".tmp/Cakefile.coffee"
    bundleRun 'docco', files, ->
      run 'rm', [ ".tmp/Cakefile.coffee" ]

# Defines a task that compile the sass stylesheets.
task 'sass', 'Compiles the widgets stylesheet', ->
  run 'sass', [
    "css/widgets.sass:css/widgets.css",
    "--style","compressed" ]

  run 'sass', [
    "css/styles.sass:css/styles.css",
    "--style","compressed" ]

# Defines a task that compiles a demo file and open it in a browser.
task 'demo', eat("Creates a demo file in the .tmp directory and then
                  run it in a browser"), ->
  hamlcompile "templates/demo.hamlc", ".tmp/demo.html", {}, ->
    run 'coffee', ['-o','.tmp','--compile','demos/demo.coffee' ], ->
      run 'gnome-open', [ ".tmp/demo.html" ]

# Runs all files through coffeelint.
task 'lint', 'Lint the widgets', ->

  files = [ "Cakefile", "test/#{TestDependencies[0]}.coffee" ]
  files.push "src/#{file}.coffee" for file in Sources
  files.push "test/test-#{file}.coffee" for file in Units

  batch = new Batch ( lintCommand file for file in files )
  batch.run()
