fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'

testTmp = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Temporary tests</title>
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
        #qunit-tests .value {
            font-weight:bold;
        }
        h4 {
            margin-top:4px;
            margin-bottom:4px;
        }        
    </style>
</head>
<body>
    <h1 id="qunit-header">Temporary tests</h1>
    <h2 id="qunit-banner"></h2>
    <div id="qunit-testrunner-toolbar"></div>
    <h2 id="qunit-userAgent"></h2>
    <ol id="qunit-tests"></ol>
    <div id="qunit-fixture">test markup</div>
</body>
"""

contents = [
    "keys",
    "mixins",
    "module",
    "widgets",
    "container",
    "button",
    "textinput",
    "textarea",
    "checkbox",
    "radio",
    "radiogroup",
    "numeric-widget",
    "slider",
    "stepper",
    "filepicker",
    "menus",
    "selects",
    "colorpicker",
    "dates",
    "jquery"
]
testContents =[
    "test-helpers",
    "test-keys",
    "test-widgets",
    "test-container",
    "test-button",
    "test-textinput",
    "test-textarea",
    "test-checkbox",
    "test-radio",
    "test-radiogroup",
    "test-numeric-widget",
    "test-slider",
    "test-stepper",
    "test-filepicker",
    "test-menus",
    "test-selects",
    "test-colorpicker",
    "test-dates",
    "test-jquery"
]
dependencies=
    'keys'            :[]
    'widgets'         :[ "keys", "module", "mixins" ]
    'container'       :[ "keys", "module", "mixins", "widgets" ]
    'button'          :[ "keys", "module", "mixins", "widgets" ]
    'textinput'       :[ "keys", "module", "mixins", "widgets" ]
    'textarea'        :[ "keys", "module", "mixins", "widgets" ]
    'checkbox'        :[ "keys", "module", "mixins", "widgets" ]
    'radio'           :[ "keys", "module", "mixins", "widgets", "checkbox" ]
    'radiogroup'      :[ "keys", "module", "mixins", "widgets", "checkbox", "radio" ]
    'numeric-widget'  :[ "keys", "module", "mixins", "widgets" ]
    'slider'          :[ "keys", "module", "mixins", "widgets", "numeric-widget" ]
    'stepper'         :[ "keys", "module", "mixins", "widgets", "numeric-widget" ]
    'filepicker'      :[ "keys", "module", "mixins", "widgets" ]
    'menus'           :[ "keys", "module", "mixins", "widgets" ]
    'selects'         :[ "keys", "module", "mixins", "widgets", "menus" ]
    'colorpicker'     :[ "keys", "module", "mixins", "widgets", "textinput", "checkbox", "radio", "radiogroup" ]
    'dates'           :[ "keys", "module", "mixins", "widgets" ]
    'jquery'          :contents[ 0..-2 ]

try
    fs.lstatSync ".tmp"
catch e
    fs.mkdirSync ".tmp"

try
    fs.lstatSync ".tmp/test-tmp.html"
catch e
    fs.writeFileSync ".tmp/test-tmp.html", testTmp

join = ( dir, contents, inFile, callback ) ->
    files = ( "#{dir}/#{file}.coffee" for file in contents )

    options = ['--join', inFile, '--compile' ].concat files

    coffee = spawn 'coffee', options
    coffee.stdout.on 'data', (data) -> print data.toString()
    coffee.stderr.on 'data', (data) -> print data.toString()
    coffee.on 'exit', (status) -> callback?() if status is 0

testTask=(file)->
    task "test:#{file}", "Run tests for the #{file} file", ->
        src = ".tmp/widgets.js"
        test = ".tmp/test-widgets.js"

        join "src", dependencies[ file ].concat( file ), src, ->
            console.log "#{file} sources compiled"
        
            join "tests", [ "test-helpers", "test-#{file}" ], test, ->
                console.log "#{file} tests compiled"

                o = spawn 'firefox', [ ".tmp/test-tmp.html" ]
                o.stdout.on 'data', (data) -> print data.toString()
                o.stderr.on 'data', (data) -> print data.toString()
                o.on 'exit', (status) -> callback?() if status is 0

testTask file for file in contents 

task 'test:all', 'Compiles and runs all the tests', ->
    file = ".tmp/widgets.js"
    join "src", contents, file, ->
        console.log "all sources generated"

        file = ".tmp/test-widgets.js"
        join "tests", testContents, file, ->
            console.log "all tests generated"

            o = spawn 'firefox', [ ".tmp/test-tmp.html" ]
            o.stdout.on 'data', (data) -> print data.toString()
            o.stderr.on 'data', (data) -> print data.toString()
            o.on 'exit', (status) -> callback?() if status is 0
            
task 'build', "Compiles the sources and the documentation", ->
    invoke "build:lib"
    invoke "docs"

task 'build:lib', 'Generate the whole lib file', ->
    file = "lib/widgets.js"
    join "src", contents, file, ->
        console.log "#{file} generated"

task 'docs', 'Generate annotated source code with Docco', ->
    files = ( "src/#{file}.coffee" for file in contents )
    docco = spawn 'docco', files
    docco.stdout.on 'data', (data) -> print data.toString()
    docco.stderr.on 'data', (data) -> print data.toString()
    docco.on 'exit', (status) -> callback?() if status is 0