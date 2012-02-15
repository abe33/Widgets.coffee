fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'

allFiles = [
    "keys",       "mixins",         "module",   "widgets",     "container", 
    "button",     "textinput",      "textarea", "checkbox",    "radio",
    "radiogroup", "numeric-widget", "slider",   "stepper",     "filepicker", 
    "menus",      "selects",        "dates",    "colorpicker", "jquery"     ]

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
        depends:[ "keys", "module", "mixins", "widgets", "checkbox" ]
        test:"test-radio"
    'radiogroup':
        depends:[ "keys", "module", "mixins", "widgets", "checkbox", "radio" ]
        test:"test-radiogroup"
    'numeric-widget':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-numeric-widget"
    'slider':
        depends:[ "keys", "module", "mixins", "widgets", "numeric-widget" ]
        test:"test-slider"
    'stepper':
        depends:[ "keys", "module", "mixins", "widgets", "numeric-widget" ]
        test:"test-stepper"
    'filepicker':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-filepicker"
    'menus':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-menus"
    'selects':
        depends:[ "keys", "module", "mixins", "widgets", "menus" ]
        test:"test-selects"
    'dates':
        depends:[ "keys", "module", "mixins", "widgets" ]
        test:"test-dates"
    'colorpicker':
        depends:[ "keys", "module", "mixins", "widgets", "textinput", "checkbox", "radio", "radiogroup" ]
        test:"test-colorpicker"
    'jquery':
        depends:allFiles[0..-2]
        test:"test-jquery"

join = ( dir, contents, inFile, callback ) ->
    files = ( "#{dir}/#{file}.coffee" for file in contents )

    options = ['--join', inFile, '--compile' ].concat files

    coffee = spawn 'coffee', options
    coffee.stdout.on 'data', (data) -> print data.toString()
    coffee.stderr.on 'data', (data) -> print data.toString()
    coffee.on 'exit', (status) -> callback?() if status is 0

testTask=(file)->
    task "test:#{file}", "Compiles and runs tests for the #{file} file", ->
        src = ".tmp/widgets.js"
        test = ".tmp/test-widgets.js"

        join "src", compilationUnits[ file ].depends.concat( file ), src, ->
            console.log "#{file} sources compiled"
        
            join "tests", allTestsDependencies.concat( compilationUnits[ file ].test ), test, ->
                console.log "#{file} tests compiled"

                o = spawn 'firefox', [ ".tmp/test-tmp.html" ]
                o.stdout.on 'data', (data) -> print data.toString()
                o.stderr.on 'data', (data) -> print data.toString()
                o.on 'exit', (status) -> callback?() if status is 0

testTask file for file of compilationUnits 

task 'test:all', 'Compiles and runs all the tests', ->
    file = ".tmp/widgets.js"
    join "src", allFiles, file, ->
        console.log "all sources generated"
        allTests = ( compilationUnits[ file ].test for file of compilationUnits )
        file = ".tmp/test-widgets.js"
        join "tests", allTestsDependencies.concat( allTests ), file, ->
            console.log "all tests generated"

            o = spawn 'firefox', [ ".tmp/test-tmp.html" ]
            o.stdout.on 'data', (data) -> print data.toString()
            o.stderr.on 'data', (data) -> print data.toString()
            o.on 'exit', (status) -> callback?() if status is 0
            
task 'build', "Compiles the javascript sources and generates the documentation", ->
    invoke "build:lib"
    invoke "docs"

task 'build:lib', 'Compiles the javascript sources', ->
    file = "lib/widgets.js"
    join "src", allFiles, file, ->
        console.log "#{file} generated"

task 'docs', 'Generate annotated source code with Docco', ->
    files = ( "src/#{file}.coffee" for file in allFiles )
    docco = spawn 'docco', files
    docco.stdout.on 'data', (data) -> print data.toString()
    docco.stderr.on 'data', (data) -> print data.toString()
    docco.on 'exit', (status) -> callback?() if status is 0

testTmp = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Widgets Tests</title>
    <link rel="stylesheet" href="../css/styles.css" media="screen">
    <link rel="stylesheet" href="../css/widgets.css" media="screen">
    <link rel="stylesheet" href="../depends/qunit.css" media="screen">
    <script type="text/javascript" src="../depends/qunit.js"></script>
    <script type="text/javascript" src="../depends/jquery-1.6.1.min.js"></script>
    <script type="text/javascript" src="../depends/jquery.mousewheel.js"></script>
    <script type="text/javascript" src="../depends/hamcrest.min.js"></script>
    <script type="text/javascript" src="../depends/signals.js"></script>
    <script type="text/javascript" src="./widgets.js"></script>
    <script type="text/javascript" src="./test-widgets.js"></script>   
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
