fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'

allFiles = [
    "keys",       "mixins",         "module",   "widgets",     "container",
    "button",     "textinput",      "textarea", "checkbox",    "radio",
    "radiogroup", "numeric-widget", "slider",   "stepper",     "filepicker",
    "menus",      "selects",        "calendar", "dates",       "colorpicker",
    "jquery",     "builder"
]

allTestsDependencies = [ "test-helpers" ]
compilationUnits=
    'keys':
        depends:[]
        test:"test-keys"
    'widgets':
        depends:[ "keys", "module", "mixins" ]
        test:"test-widgets"
    'container':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-container"
    'button':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-button"
    'textinput':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-textinput"
    'textarea':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-textarea"
    'checkbox':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-checkbox"
    'radio':
        depends:[ "keys", "module", "mixins", "widgets",
                  "checkbox" ]
        test:"test-radio"
    'radiogroup':
        depends:[ "keys", "module", "mixins", "widgets",
                  "checkbox", "radio" ]
        test:"test-radiogroup"
    'numeric-widget':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-numeric-widget"
    'slider':
        depends:[ "keys", "module", "mixins", "widgets",
                  "numeric-widget" ]
        test:"test-slider"
    'stepper':
        depends:[ "keys", "module", "mixins", "widgets",
                  "numeric-widget" ]
        test:"test-stepper"
    'filepicker':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-filepicker"
    'menus':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-menus"
    'selects':
        depends:[ "keys", "module", "mixins", "widgets",
                  "menus" ]
        test:"test-selects"
    'calendar':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-calendar"
    'dates':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-dates"
    'colorpicker':
        depends:[ "keys", "module", "mixins", "widgets",
                  "container", "textinput", "checkbox",
                  "radio", "radiogroup" ]
        test:"test-colorpicker"
    'jquery':
        depends:allFiles[0..-2]
        test:"test-jquery"
    'builder':
        depends:[ "keys", "module", "mixins", "widgets", "button" ]
        test:"test-builder"

class Batch
    constructor:( @commands )->
        @iterator = -1

    run:->
        if @iterator + 1 < @commands.length
            @commands[ @iterator + 1 ] =>
                @run()
            @iterator += 1

run=( command, options, callback )->
    exe = spawn command, options
    exe.stdout.on 'data', ( data )-> print data.toString()
    exe.stderr.on 'data', ( data )-> print data.toString()
    exe.on 'exit', ( status )-> callback?()

join=( dir, contents, inFile, callback )->
    files = ( "#{dir}/#{file}.coffee" for file in contents )

    options = ['--join', inFile, '--compile' ].concat files

    run 'coffee', options, callback

testTask=(file)->
    task "test:#{file}", "Compiles and runs tests for the #{file} file", ->
        src = ".tmp/widgets.js"
        test = ".tmp/test-widgets.js"

        join "src", compilationUnits[ file ].depends.concat( file ), src, ->
            console.log "#{file} sources compiled"

            join "tests",
                 allTestsDependencies.concat( compilationUnits[ file ].test ),
                 test, ->
                     console.log "#{file} tests compiled"

                     run 'firefox', [ ".tmp/test-tmp.html" ]

lint=( file, callback )->
    console.log "> Do '#{file}' has lints ?"
    run 'coffeelint', [ "-f", "lint.json", file ], callback

lintCommand=( file )-> ( callback )-> lint file, callback

# Creates a test task by compilation units.
testTask file for file of compilationUnits

task 'test:all', 'Compiles and runs all the tests', ->
    file = ".tmp/widgets.js"
    join "src", allFiles, file, ->
        console.log "all sources generated"
        allTests = ( compilationUnits[file].test for file of compilationUnits )
        file = ".tmp/test-widgets.js"
        join "tests", allTestsDependencies.concat( allTests ), file, ->
            console.log "all tests generated"

            run 'firefox', [ ".tmp/test-tmp.html" ]

task 'build', """Compiles the javascript sources
                 and generates the documentation""", ->
    invoke "build:lib"
    invoke "docs"

task 'build:lib', 'Compiles the javascript sources', ->
    file = "lib/widgets.js"
    join "src", allFiles, file, ->
        console.log "#{file} generated"

task 'docs', 'Generate annotated source code with Docco', ->
    files = ( "src/#{file}.coffee" for file in allFiles )
    run 'docco', files

task 'lint', 'Lint the widgets', ->

    files = [ "Cakefile", "tests/#{allTestsDependencies[0]}.coffee" ]
    for file in allFiles
        files.push "src/#{file}.coffee"
    for k, { test } of compilationUnits
        files.push "tests/#{test}.coffee"


    batch = new Batch ( lintCommand file for file in files )
    batch.run()

    # lint files[0], ->
    #     console.log "this is the end"
    #     lint files[1]


testTmp = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Widgets Tests</title>
    <link rel="stylesheet" href="../css/styles.css" media="screen">
    <link rel="stylesheet" href="../css/widgets.css" media="screen">
    <link rel="stylesheet" href="../depends/qunit.css" media="screen">
    <script type="text/javascript"
            src="../depends/qunit.js"></script>
    <script type="text/javascript"
            src="../depends/jquery-1.6.1.min.js"></script>
    <script type="text/javascript"
            src="../depends/jquery.mousewheel.js"></script>
    <script type="text/javascript"
            src="../depends/hamcrest.min.js"></script>
    <script type="text/javascript"
            src="../depends/signals.js"></script>
    <script type="text/javascript"
            src="./widgets.js"></script>
    <script type="text/javascript"
            src="./test-widgets.js"></script>
    <style>
        #qunit-tests .value { font-weight:bold; }
        h4 {  margin-top:4px; margin-bottom:4px; }
    </style>
</head>
<body>
    <h1 id="qunit-header">Widgets Tests</h1>
    <h2 id="qunit-banner"></h2>
    <div id="qunit-testrunner-toolbar"></div>
    <h2 id="qunit-userAgent"></h2>
    <ol id="qunit-tests"></ol>
    <div id="qunit-fixture">test markup</div>
</body>
"""

try
    fs.lstatSync ".tmp"
catch e
    fs.mkdirSync ".tmp"

try
    fs.lstatSync ".tmp/test-tmp.html"
catch e
    fs.writeFileSync ".tmp/test-tmp.html", testTmp
